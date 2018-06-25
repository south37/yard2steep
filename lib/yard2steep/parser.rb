require 'yard2steep/ast'

module Yard2steep
  class Parser
    S_RE    = /[\s\t]*/
    S_P_RE  = /[\s\t]+/
    PRE_RE  = /^#{S_RE}/
    POST_RE = /#{S_RE}$/

    # NOTE: CLASS_RE may not be correct.
    CLASS_RE = /#{PRE_RE}(class|module)#{S_P_RE}(\w+)#{POST_RE}/
    # NOTE: END_RE may not be correct.
    END_RE   = /#{PRE_RE}end#{POST_RE}/

    BEGIN_END_RE = /#{S_P_RE}(if|unless|do|while|until|case|for)(?:#{S_P_RE}.*)?$/

    COMMENT_RE         = /#{PRE_RE}#/
    TYPE_WITH_PAREN_RE = /\[([^\]]*)\]/

    PARAM_RE  = /#{COMMENT_RE}#{S_P_RE}@param#{S_P_RE}#{TYPE_WITH_PAREN_RE}#{S_P_RE}(\w+)/
    RETURN_RE = /#{COMMENT_RE}#{S_P_RE}@return#{S_P_RE}#{TYPE_WITH_PAREN_RE}/

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

    # NOTE: METHOD_RE may not be correct.
    METHOD_RE = /
      #{PRE_RE}
      def
      #{S_P_RE}
      (\w+)
      (
        (?:#{ARGS_RE})
        ?
      )
      #{POST_RE}
    /x

    STATES = {
      class:  "STATES.class",
      method: "STATES.method",
    }

    ANY_TYPE = 'any'

    def initialize
      # NOTE: set at parse
      @file = nil

      main = ClassNode::Main
      @ast = main

      # Parser state
      @state = STATES[:class]
      # Stack stores begining keyword of end
      @stack = []

      # NOTE: reset class context
      @current_class = main

      reset_method_context!
    end

    def reset_method_context!
      # Current method context. Flushed when method definition is parsed.
      @p_types = {}
      @r_type  = nil
      @m_name  = nil
    end

    def parse(file, text)
      @file = file
      text.split(/\n|;/).each do |l|
        parse_line(l)
      end

      @ast
    end

    # NOTE: Current implementation override `@p_type`, `@r_type` if it appears
    # multiple times before method definition.
    def parse_line(l)
      return if try_parse_end(l)
      return if try_parse_begin_end(l)

      if @state == STATES[:class]
        return if try_parse_class(l)
        return if try_parse_param(l)
        return if try_parse_return(l)
        return if try_parse_method(l)
      end

      # NOTE: Reach here when other case
    end

    def try_parse_end(l)
      return false if !l.match?(END_RE)

      if @stack.size == 0
        raise "Invalid end: #{@file}"
      end

      last = @stack.pop
      if STATES.values.include?(last)
        case @state
        when STATES[:method]
          @state = STATES[:class]
        when STATES[:class]
          @current_class = @current_class.parent
        else
          raise "Invalid state: #{@state}"
        end
      end

      true
    end

    def try_parse_begin_end(l)
      m = l.match(BEGIN_END_RE)
      return false if m.nil?

      @stack.push(m[1])

      true
    end

    def try_parse_class(l)
      m = l.match(CLASS_RE)
      return false if m.nil?

      # NOTE: If class definition is found before method definition, yard
      # annotation is ignored.
      reset_method_context!

      c = ClassNode.new(
        kind:   m[1],
        c_name: m[2],
        parent: @current_class,
      )
      @current_class.append_child(c)
      @current_class = c
      @stack.push(STATES[:class])

      true
    end

    def try_parse_param(l)
      m = l.match(PARAM_RE)
      return false if m.nil?

      p = PTypeNode.new(
        p_type: m[1],
        p_name: m[2],
      )
      @p_types[p.p_name] = p

      true
    end

    def try_parse_return(l)
      m = l.match(RETURN_RE)
      return false if m.nil?

      @r_type = m[1]

      true
    end

    def try_parse_method(l)
      m = l.match(METHOD_RE)
      return false if m.nil?

      Util.assert! { m[1].is_a?(String) && m[2].is_a?(String) }

      @m_name = m[1]
      p_list = parse_method_params(m[2].strip)

      m_node = MethodNode.new(
        p_list: p_list,
        r_type: (@r_type || ANY_TYPE),
        m_name: @m_name,
      )
      @current_class.append_m(m_node)
      reset_method_context!
      @state = STATES[:method]
      @stack.push(STATES[:method])

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
          # TODO: Add warn when value exists
          name = p.split(':')[0]
          PNode.new(
            type_node: type_node(name),
            style:     PNode::STYLE[:keyword],
          )
        else
          PNode.new(
            type_node: type_node(p),
            style:     PNode::STYLE[:normal],
          )
        end
      end
    end

    ##
    # Helper
    def type_node(p)
      @p_types[p] || PTypeNode.new(p_type: ANY_TYPE, p_name: p)
    end
  end
end
