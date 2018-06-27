require 'yard2steep/ast'

module Yard2steep
  class Parser
    S_RE    = /[\s\t]*/
    S_P_RE  = /[\s\t]+/
    PRE_RE  = /^#{S_RE}/
    POST_RE = /#{S_RE}$/

    CLASS_RE = /
      #{PRE_RE}
      (class)
      #{S_P_RE}
      (\w+)
      (?:
        #{S_P_RE}
        <
        #{S_P_RE}
        \w+
      )?
      #{POST_RE}
    /x
    MODULE_RE = /
      #{PRE_RE}
      (module)
      #{S_P_RE}
      (\w+)
      #{POST_RE}
    /x
    S_CLASS_RE = /#{PRE_RE}class#{S_P_RE}<<#{S_P_RE}\w+#{POST_RE}/
    END_RE     = /#{PRE_RE}end#{POST_RE}/

    CONSTANT_ASSIGN_RE = /
      #{PRE_RE}
      (
        [A-Z\d_]+
      )
      #{S_RE}
      =
      .*
      #{POST_RE}
    /x

    # TODO(south37) `POSTFIX_IF_RE` is wrong. Fix it.
    POSTFIX_IF_RE = /
      #{PRE_RE}
      (?:return|break|next|p|print|raise)
      #{S_P_RE}
      .*
      (?:if|unless)
      #{S_P_RE}
      .*
      $
    /x

    BEGIN_END_RE = /
      #{S_P_RE}
      (if|unless|do|while|until|case|for|begin)
      (?:#{S_P_RE}.*)?
    $/x

    COMMENT_RE         = /#{PRE_RE}#/
    TYPE_WITH_PAREN_RE = /\[([^\]]*)\]/

    PARAM_RE  = /
      #{COMMENT_RE}
      #{S_P_RE}
      @param
      #{S_P_RE}
      #{TYPE_WITH_PAREN_RE}
      #{S_P_RE}
      (\w+)
    /x
    RETURN_RE = /
      #{COMMENT_RE}
      #{S_P_RE}
      @return
      #{S_P_RE}
      #{TYPE_WITH_PAREN_RE}
    /x

    PAREN_RE = /
      \(
        ([^)]*)
      \)
    /x

    # NOTE: This implementation should be fixed.
    ARGS_RE   = /
      #{S_RE}
      \(
        [^)]*
      \)
      |
      #{S_P_RE}
      .*
    /x

    METHOD_RE = /
      #{PRE_RE}
      def
      #{S_P_RE}
      (
        (?:\w+\.)?
        \w+
        (?:\!|\?)?
      )
      #{S_RE}
      (
        (?:#{ARGS_RE})
        ?
      )
      #{POST_RE}
    /x

    STATES = {
      class:   "STATES.class",
      s_class: "STATES.s_class",  # singleton class
      method:  "STATES.method",
    }

    ANY_TYPE = 'any'
    ANY_BLOCK_TYPE = '{ (any) -> any }'

    def initialize
      # Debug flag
      @debug = false

      # NOTE: set at parse
      @file = nil

      main = AST::ClassNode.create_main
      @ast = main

      # Stack of parser state
      @stack = [STATES[:class]]
      # Parser state. Being last one of STATES in @stack.
      @state = STATES[:class]

      # NOTE: reset class context
      @current_class = main

      reset_method_context!
    end

    def parse(file, text, debug: false)
      @debug = debug

      debug_print!("Start parsing: #{file}")

      @file = file
      text.split(/\n|;/).each do |l|
        parse_line(l)
      end

      @ast
    end

  # NOTE: steep cause error when `private` is used. So we does not use it.
  # private

    def reset_method_context!
      # Current method context. Flushed when method definition is parsed.
      @p_types = {}
      @r_type  = nil
      @m_name  = nil
    end

    # NOTE: Current implementation override `@p_type`, `@r_type` if it appears
    # multiple times before method definition.
    def parse_line(l)
      # At first, try parsing comment
      return if try_parse_comment(l)

      return if try_parse_end(l)
      return if try_parse_postfix_if(l)
      return if try_parse_begin_end(l)

      case @state
      when STATES[:class]
        return if try_parse_constant(l)
        return if try_parse_class(l)
        return if try_parse_singleton_class(l)
        return if try_parse_method(l)
      when STATES[:s_class]
        return if try_parse_method_with_no_action(l)
      when STATES[:method]
        # Do nothing
      else
        raise "invalid state: #{@state}"
      end

      # NOTE: Reach here when other case
    end

    def try_parse_comment(l)
      return false if !l.match?(COMMENT_RE)

      try_parse_param_or_return(l)

      true
    end

    def try_parse_param_or_return(l)
      if @state == STATES[:class]
        return if try_parse_param(l)
        return if try_parse_return(l)
      end
    end

    def try_parse_end(l)
      return false if !l.match?(END_RE)

      # NOTE: Print before pop state, so offset is -2
      debug_print!("end", offset: -2)

      if stack_is_empty?
        raise "Invalid end: #{@file}"
      end

      pop_state!

      true
    end

    # NOTE: This implementation is wrong. Used only for skipping postfix if.
    def try_parse_postfix_if(l)
      l.match?(POSTFIX_IF_RE)
    end

    def try_parse_begin_end(l)
      m = l.match(BEGIN_END_RE)
      return false if m.nil?

      debug_print!(m[1])

      push_state!(m[1])

      true
    end

    def try_parse_class(l)
      m = (l.match(MODULE_RE) || l.match(CLASS_RE))
      return false if m.nil?

      debug_print!("#{m[1]} #{m[2]}")

      # NOTE: If class definition is found before method definition, yard
      # annotation is ignored.
      reset_method_context!

      c = AST::ClassNode.new(
        kind:   m[1],
        c_name: m[2],
        parent: @current_class,
      )
      @current_class.append_child(c)
      @current_class = c

      push_state!(STATES[:class])

      true
    end

    def try_parse_constant(l)
      m = l.match(CONSTANT_ASSIGN_RE)
      return false if m.nil?

      c = AST::ConstantNode.new(
        name:  m[1],
        klass: @current_class,
      )
      @current_class.append_constant(c)
      true
    end

    def try_parse_singleton_class(l)
      m = l.match(S_CLASS_RE)
      return false if m.nil?

      debug_print!("class <<")

      push_state!(STATES[:s_class])

      true
    end

    def try_parse_param(l)
      m = l.match(PARAM_RE)
      return false if m.nil?

      p = AST::PTypeNode.new(
        p_type: normalize_type(m[1]),
        p_name: m[2],
        kind:   AST::PTypeNode::KIND[:normal],
      )
      @p_types[p.p_name] = p

      true
    end

    def try_parse_return(l)
      m = l.match(RETURN_RE)
      return false if m.nil?

      @r_type = normalize_type(m[1])

      true
    end

    def try_parse_method(l)
      m = l.match(METHOD_RE)
      return false if m.nil?

      debug_print!("def #{m[1]}")

      Util.assert! { m[1].is_a?(String) && m[2].is_a?(String) }

      @m_name = m[1]
      p_list = parse_method_params(m[2].strip)

      m_node = AST::MethodNode.new(
        p_list: p_list,
        r_type: (@r_type || ANY_TYPE),
        m_name: @m_name,
      )
      @current_class.append_m(m_node)
      reset_method_context!

      push_state!(STATES[:method])

      true
    end

    def try_parse_method_with_no_action(l)
      m = l.match(METHOD_RE)
      return false if m.nil?

      debug_print!("def #{m[1]}")

      # Do no action

      push_state!(STATES[:method])

      true
    end

    def parse_method_params(params_s)
      Util.assert! { params_s.is_a?(String) }

      # NOTE: Remove parenthesis
      if (m = params_s.match(PAREN_RE))
        params_s = m[1]
      end

      if params_s == ''
        if @p_types.size > 0
          print "warn: #{@m_name} has no args, but annotated as #{@p_types}"
        end
        return []
      end

      params_s.split(',').map(&:strip).map do |p|
        if p.include?(':')
          name, default_value = p.split(':')
          if default_value
            AST::PNode.new(
              type_node: type_node(name),
              style:     AST::PNode::STYLE[:keyword_with_default],
            )
          else
            AST::PNode.new(
              type_node: type_node(name),
              style:     AST::PNode::STYLE[:keyword],
            )
          end
        else
          AST::PNode.new(
            type_node: type_node(p),
            style:     AST::PNode::STYLE[:normal],
          )
        end
      end
    end

    def push_state!(state)
      if STATES.values.include?(state)
        @state = state
      end
      @stack.push(state)
    end

    def pop_state!
      state = @stack.pop
      if STATES.values.include?(state)
        # Restore prev class
        if state == STATES[:class]
          @current_class = @current_class.parent
        end

        # Restore prev state
        @state = @stack.select { |s| STATES.values.include?(s) }.last
        Util.assert! { !@state.nil? }
      end
    end

    def stack_is_empty?
      @stack.size <= 1
    end

    ##
    # Helper
    def type_node(p)
      if @p_types[p]
        @p_types[p]
      else
        # NOTE: `&` represents block variable
        if p[0] == '&'
          AST::PTypeNode.new(
            p_type: ANY_BLOCK_TYPE,
            p_name: p[1..-1],
            kind:   AST::PTypeNode::KIND[:block],
          )
        else
          AST::PTypeNode.new(
            p_type: ANY_TYPE,
            p_name: p,
            kind:   AST::PTypeNode::KIND[:normal],
          )
        end
      end
    end

    def debug_print!(message, offset: 0)
      print "#{' ' * (@stack.size * 2 + offset)}#{message}\n" if @debug
    end

    ARRAY_TYPE_RE = /^
      Array
      #{S_RE}
      <
        ([^>]+)
      >
      #{S_RE}
    $/x
    FIXED_ARRAY_TYPE_RE = /^
      Array
      #{S_RE}
      \(
        ([^)]+)
      \)
      #{S_RE}
    $/x
    HASH_TYPE_RE = /^
      Hash
      #{S_RE}
      \{
        #{S_RE}
        ([^=]+)
        #{S_RE}
        =>
        #{S_RE}
        ([^}]+)
        #{S_RE}
      \}
      #{S_RE}
    $/x

    # NOTE: normalize type to steep representation
    def normalize_type(type)
      if type[0..4] == 'Array'.freeze
        if type == 'Array'.freeze
          'Array<any>'.freeze
        elsif (m = ARRAY_TYPE_RE.match(type))
          "Array<#{normalize_multi_type(m[1])}>"
        elsif (m = FIXED_ARRAY_TYPE_RE.match(type))
          "Array<#{normalize_multi_type(m[1])}>"
        else
          raise "invalid Array type: #{type}"
        end
      elsif type[0..3] == 'Hash'.freeze
        if type == 'Hash'.freeze
          'Hash<any, any>'.freeze
        elsif (m = HASH_TYPE_RE.match(type))
          "Hash<#{normalize_multi_type(m[1])}, #{normalize_multi_type(m[2])}>"
        else
          raise "invalid Hash type: #{type}"
        end
      else
        normalize_multi_type(type)
      end
    end

    def normalize_multi_type(type_s)
      type_s.split(',').map(&:strip).uniq.join(' | ')
    end
  end
end
