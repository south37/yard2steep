require 'ripper'

require 'yard2steep/type'
require 'yard2steep/ast'
require 'yard2steep/util'

module Yard2steep
  class Parser
    S_RE = /[\s\t]*/
    TYPE_WITH_PAREN_RE = /
      \[
      (
        [^\]]
        *
      )
      \]
    /x
    COMMENT_RE = /^
      \#
      #{S_RE}
      @(?:param|return)
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
    /x
    PARAM_RE  = /
      \#
      #{S_RE}
      @param
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
      #{S_RE}
      (\w+)
    /x
    RETURN_RE = /
      \#
      #{S_RE}
      @return
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
    /x

    ANY_TYPE = 'any'
    ANY_BLOCK_TYPE = '{ (any) -> any }'

    def initialize
      # Debug flag
      @debug = false

      # NOTE: set at parse
      @file = nil

      @comments_map = {}
    end

    # @param [String] file
    # @param [String] text
    # @param [bool] debug
    # @return [AST::ClassNode]
    def parse(file, text, debug: false)
      @debug = debug

      @file = file
      debug_print!("Start parsing: #{file}")

      @comments_map = extract_comments(text)

      main = AST::ClassNode.create_main
      @ast = main

      # NOTE: reset class context
      @current_class = main

      parse_program(text)

      @ast
    end

    # @param [String] text
    # @return [void]
    def parse_program(text)
      r_ast = Ripper.sexp(text)
      # NOTE: r_ast is array such as
      # [:program,
      #   [...]]
      Util.assert! { r_ast[0] == :program && r_ast[1].is_a?(Array) }
      parse_stmts(r_ast[1])
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_stmts(r_ast)
      r_ast.each do |node|
        parse_stmt(node)
      end
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_stmt(r_ast)
      n_type = r_ast[0]

      case n_type
      when :defs
        parse_defs(r_ast)
      when :def
        parse_def(r_ast)
      when :class, :module
        parse_class_or_module(r_ast)
      when :assign
        parse_assign(r_ast)
      when :command
        parse_command(r_ast)
      when :method_add_arg
        parse_method_add_arg(r_ast)
      end

      # Do nothing for other stmt
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_defs(r_ast)
      # NOTE: r_ast is array such as
      # [:defs,
      #   [:var_ref, [:@kw, "self", [1, 14]]],
      #   [:@period, ".", [1, 18]],
      #   [:@ident, "my_method", [1, 19]],
      #   [:params, nil, nil, nil, nil, nil, nil, nil],
      #   [:bodystmt, [[:void_stmt]], nil, nil, nil]]

      Util.assert! {
        r_ast.size == 6 &&
          r_ast[0] == :defs &&
            r_ast[1][0] == :var_ref &&
            r_ast[1][1][0] == :@kw &&
            r_ast[1][1][1].is_a?(String) &&
            r_ast[1][1][2].is_a?(Array) &&
            r_ast[2][0] == :@period &&
            r_ast[3][0] == :@ident &&
            r_ast[3][1].is_a?(String)
      }

      m_name = "#{r_ast[1][1][1]}.#{r_ast[3][1]}"
      m_loc  = r_ast[1][1][2][0]
      params = r_ast[4]
      # NOTE: We also want to check bodystmt
      # bodystmt = r_ast[5]

      parse_method_impl(m_name, m_loc, params)
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_def(r_ast)
      # NOTE: r_ast is array such as
      # [:def,
      #   [:@ident, "first", [3, 4]],
      #   [:paren, [:params, ...]],
      #   [:bodystmt, [[:array, nil]], nil, nil, nil]]]

      Util.assert! {
        r_ast.size == 4 &&
          r_ast[0] == :def &&
          r_ast[1][0] == :@ident &&
          r_ast[1][1].is_a?(String) &&
          r_ast[1][2].is_a?(Array)
      }

      m_name = r_ast[1][1]
      m_loc  = r_ast[1][2][0]
      params = r_ast[2]
      # NOTE: We also want to check bodystmt
      # bodystmt = r_ast[3]

      parse_method_impl(m_name, m_loc, params)
    end

    # @param [String] m_name
    # @param [Integer] m_loc
    # @param [Array] params
    # @return [void]
    def parse_method_impl(m_name, m_loc, params)
      within_context do
        extract_p_types!(m_loc)

        p_list = parse_params(params)

        # NOTE: We also want to check bodystmt
        # parse_mbody(bodystmt)

        m_node = AST::MethodNode.new(
          p_list: p_list,
          r_type: (@r_type || ANY_TYPE),
          m_name: m_name,
        )
        @current_class.append_m(m_node)
      end
    end

    # @param [Integer] m_loc represents location of method definition
    # @return [void]
    def extract_p_types!(m_loc)
      Util.assert! { m_loc >= 0 }
      l = m_loc - 1
      while l >= 0
        comment = @comments_map[l]
        break unless comment  # nil when no more comment exist

        parse_comment!(comment)
        l -= 1
      end
    end

    # @param [String] comment
    # @return [void]
    def parse_comment!(comment)
      return if try_param_comment(comment)
      return if try_return_comment(comment)
      raise "Must not reach here!"
    end

    # @param [String] comment
    # @return [bool]
    def try_param_comment(comment)
      m = comment.match(PARAM_RE)
      return false unless m

      p = AST::PTypeNode.new(
        p_type: normalize_type(m[1]),
        p_name: m[2],
        kind:   AST::PTypeNode::KIND[:normal],
      )
      @p_types[p.p_name] = p

      true
    end

    # @param [String] comment
    # @return [bool]
    def try_return_comment(comment)
      m = comment.match(RETURN_RE)
      return false unless m

      @r_type = normalize_type(m[1])

      true
    end

    # @param [Array] r_ast
    # @return [Array<AST::PNode>]
    def parse_params(r_ast)
      # NOTE: parrams is `paren_params` or `no_paren_params`
      # paren_params: [:paren, [:params, ...]]
      # no_paren_params: [:params, ...]
      case r_ast[0]
      when :paren
        parse_paren_params(r_ast)
      when :params
        parse_no_paren_params(r_ast)
      else
        raise "invalid node"
      end
    end

    # @param [Array] r_ast
    # @return [Array<AST::PNode>]
    def parse_paren_params(r_ast)
      # NOTE: r_ast is array such as
      # [:paren, [:params, ...]]
      Util.assert! {
        r_ast[0] == :paren &&
          r_ast[1].is_a?(Array) &&
          r_ast[1][0] == :params
      }
      parse_no_paren_params(r_ast[1])
    end

    # @param [Array] params
    # @return [Array<AST::PNode>]
    def parse_no_paren_params(params)
      # NOTE: params is array such as
      # [:params,
      #   nil,
      #   nil,
      #   nil,
      #   nil,
      #   [
      #     [
      #       [:@label, "contents:", [3, 10]],
      #       false
      #     ]
      #   ],
      #   nil,
      #   nil
      # ]],
      Util.assert! { params[0] == :params && params.size == 8 }

      r = []
      n_params = (params[1] || [])
      # NOTE: n_params is array such as
      # [[:@ident, "a", [1, 7]], ...]
      n_params.each do |key|
        # TODO(south37) Optimize this check
        Util.assert! { key[0] == :@ident && key[1].is_a?(String) }
        name = key[1]
        r.push(
          AST::PNode.new(
            type_node: type_node(name),
            style:     AST::PNode::STYLE[:normal],
          )
        )
      end

      v_params = (params[2] || [])
      # NOTE: v_params is array such as
      # [
      #   [
      #     [:@ident, "a", [1, 7]],
      #     [:@int, "2", [1, 9]]
      #   ],
      #   ...
      # ]
      v_params.each do |v_param|
        key, default_v = v_param

        # TODO(south37) Optimize this check
        Util.assert! {
          key[0] == :@ident &&
            key[1].is_a?(String) &&
            default_v.is_a?(Array)
        }
        name = key[1]
        r.push(
          AST::PNode.new(
            type_node: type_node(name),
            style:     AST::PNode::STYLE[:normal_with_default],
          )
        )
      end

      n_params2 = (params[4] || [])
      # NOTE: n_params2 is array such as
      # [[:@ident, "a", [1, 7]], ...]
      n_params2.each do |key|
        # TODO(south37) Optimize this check
        Util.assert! { key[0] == :@ident && key[1].is_a?(String) }
        name = key[1]
        r.push(
          AST::PNode.new(
            type_node: type_node(name),
            style:     AST::PNode::STYLE[:normal],
          )
        )
      end

      k_params = (params[5] || [])
      # NOTE: k_params is array such as
      # [
      #   [
      #     [:@label, "contents:", [3, 10]],
      #     false
      #   ],
      #   ...
      # ],
      k_params.each do |v_param|
        key, default_v = v_param

        # TODO(south37) Optimize this check
        Util.assert! {
          key[0] == :@label &&
            key[1][-1] == ':'
        }
        name = key[1][0..-2]
        if default_v
          r.push(
            AST::PNode.new(
              type_node: type_node(name),
              style:     AST::PNode::STYLE[:keyword_with_default],
            )
          )
        else
          r.push(
            AST::PNode.new(
              type_node: type_node(name),
              style:     AST::PNode::STYLE[:keyword],
            )
          )
        end
      end

      b_param = params[7]
      # NOTE: b_params is array such as
      # [:blockarg, [:@ident, "block", [1, 8]]]
      if b_param
        Util.assert! {
          b_param[0] == :blockarg &&
            b_param[1].is_a?(Array) &&
            b_param[1][0] == :@ident &&
            b_param[1][1].is_a?(String)
        }
        name = b_param[1][1]
        r.push(
          AST::PNode.new(
            type_node: block_type_node(name),
            style:     AST::PNode::STYLE[:normal],
          )
        )
      end

      # NOTE: params[3] is `*a`, params[6] is `**a`

      r
    end

    # @return [void]
    def within_context(&block)
      # Current method context.
      @p_types = {}
      @r_type  = nil
      block.call
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_class_or_module(r_ast)
      # NOTE: r_ast is array such as
      # [:class,
      #   [:const_ref, [:@const, "OtherClass", [119, 6]]],
      #   [:var_ref, [:@const, "MyClass", [119, 19]]],
      #   [:bodystmt, [...]]]

      kind = r_ast[0].to_s

      case kind
      when "class"
        Util.assert! { r_ast.size == 4 }
        c_name_node   = r_ast[1]
        super_c_node  = r_ast[2]
        bodystmt_node = r_ast[3]
      when "module"
        Util.assert! { r_ast.size == 3 }
        c_name_node   = r_ast[1]
        super_c_node  = nil
        bodystmt_node = r_ast[2]
      else
        raise "invalid kind: #{kind}"
      end

      Util.assert! {
        c_name_node[0] == :const_ref &&
          c_name_node[1].is_a?(Array) &&
          c_name_node[1][0] == :@const &&
          c_name_node[1][1].is_a?(String)
      }
      c_name = c_name_node[1][1]
      Util.assert! {
        !super_c_node || (
          super_c_node[0] == :var_ref &&
            super_c_node[1].is_a?(Array) &&
            super_c_node[1][0] == :@const &&
            super_c_node[1][1].is_a?(String)
        )
      }
      super_c_name = super_c_node ? super_c_node[1][1] : nil

      c = AST::ClassNode.new(
        kind:    kind,
        c_name:  c_name,
        super_c: super_c_name,
        parent:  @current_class,
      )
      @current_class.append_child(c)
      @current_class = c

      parse_bodystmt(bodystmt_node)

      @current_class = @current_class.parent
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_bodystmt(r_ast)
      # NOTE:
      # [:bodystmt,
      #   [...]]
      Util.assert! {
        r_ast[0] == :bodystmt &&
          r_ast[1].is_a?(Array)
      }
      parse_stmts(r_ast[1])
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_assign(r_ast)
      # NOTE: r_ast is array such as
      # [:assign,
      #   [:var_field, [:@const, "DNA", [1, 15]]],
      #   [...]]
      Util.assert! {
        r_ast[0] == :assign &&
          r_ast[1].is_a?(Array) &&
          r_ast[1][0] == :var_field
      }
      var_type = r_ast[1][1][0]
      if var_type == :@const
        # TODO(south37) Check the value node to predict the type of the const.
        c = AST::ConstantNode.new(
          name:  r_ast[1][1][1],
          klass: @current_class,
        )
        @current_class.append_constant(c)
      end
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_command(r_ast)
      # NOTE: r_ast is array such as
      # [:command,
      #   [:@ident, "attr_reader", [1, 15]],
      #   [:args_add_block,
      #     [
      #       [:symbol_literal, [:symbol, [:@ident, "ok", [1, 28]]]]
      #     ],
      #     false
      #   ]
      # ]
      Util.assert! {
        r_ast[0] == :command &&
          r_ast[1].is_a?(Array)
      }

      # NOTE: check attr_*
      if r_ast[1][0] == :@ident
        case r_ast[1][1]
        when "attr_reader"
          parse_attr_reader(parse_command_args_add_block(r_ast[2]))
        when "attr_writer"
          # TODO(south37) Impl
          # parse_attr_writer(parse_command_args_add_block(r_ast[2]))
        when "attr_accessor"
          # TODO(south37) Impl
          # parse_attr_accessor(parse_command_args_add_block(r_ast[2]))
        end

        # Do nothing for other case
      end
    end

    # @param [Array] r_ast
    # @return [Array<String>]
    def parse_command_args_add_block(r_ast)
      # NOTE: r_ast is array such as
      #
      # [:args_add_block,
      #   [
      #     [:symbol_literal, [:symbol, [:@ident, "ok", [1, 28]]]],
      #     [:symbol_literal, [:symbol, [:@ident, "no", [1, 33]]]],
      #     [:string_literal, [:string_content, [:@tstring_content, "b", [1, 38]]]]
      #   ],
      #   false
      # ]
      Util.assert! {
        r_ast[0] == :args_add_block &&
          r_ast[1].is_a?(Array)
      }
      r = []
      r_ast[1].each do |ast|
        case ast[0]
        when :symbol_literal
          Util.assert! {
            ast[1].is_a?(Array) &&
              ast[1][0] == :symbol &&
              ast[1][1].is_a?(Array) &&
              ast[1][1][0] == :@ident &&
              ast[1][1][1].is_a?(String)
          }
          r.push(ast[1][1][1])
        when :string_literal
          Util.assert! {
            ast[1].is_a?(Array) &&
              ast[1][0] == :string_content &&
              ast[1][1].is_a?(Array) &&
              ast[1][1][0] == :@tstring_content &&
              ast[1][1][1].is_a?(String)
          }
          r.push(ast[1][1][1])
        end
        # Do nothing for other case
      end
      r
    end

    # @param [Array] r_ast
    # @return [void]
    def parse_method_add_arg(r_ast)
      # NOTE: r_ast is Array such as
      # [:method_add_arg,
      #   [:fcall, [:@ident, "attr_reader", [1, 15]]],
      #   [:arg_paren,
      #     [
      #       :args_add_block,
      #       [
      #         [:symbol_literal, [:symbol, [:@ident, "ok", [1, 28]]]]
      #       ],
      #       false
      #     ]
      #   ]
      # ]
      Util.assert! {
        r_ast[0] == :method_add_arg &&
          r_ast[1].is_a?(Array) &&
          r_ast[1][0] == :fcall &&
          r_ast[1][1].is_a?(Array) &&
          r_ast[2].is_a?(Array) &&
          r_ast[2][0] == :arg_paren &&
          r_ast[2][1].is_a?(Array) &&
          r_ast[2][1][0] == :args_add_block &&
          r_ast[2][1][1].is_a?(Array)
      }

      # NOTE: check attr_*
      if r_ast[1][1][0] == :@ident
        case r_ast[1][1][1]
        when "attr_reader"
          parse_attr_reader(parse_command_args_add_block(r_ast[2][1]))
        when "attr_writer"
          # TODO(south37) Impl
          # parse_attr_writer(parse_command_args_add_block(r_ast[2][1]))
        when "attr_accessor"
          # TODO(south37) Impl
          # parse_attr_accessor(parse_command_args_add_block(r_ast[2][1]))
        end
        # Do nothing for other case
      end
    end

    # @param [Array<String>] vars
    # @return [void]
    def parse_attr_reader(ivars)
      ivars.each do |ivarname|
        @current_class.append_ivar(
          AST::IVarNode.new(
            name: ivarname
          )
        )

        # NOTE: Attr reader should add getter method
        @current_class.append_m(
          AST::MethodNode.new(
            p_list: [],
            r_type: ANY_TYPE,
            m_name: ivarname,
          )
        )
      end
    end

    # @param [String] text
    # @return [Hash{ String => String }]
    def extract_comments(text)
      # NOTE: `Ripper.lex` returns array of array such as
      # [
      #   [[1, 0], :on_comment, "# @param [Array] contents\n", EXPR_BEG],
      #   ...
      # ]
      r = {}
      Ripper.lex(text).each do |t|
        # Check token type
        type = t[1]
        next if type != :on_comment
        # Check comment body
        comment = t[2]
        next unless comment.match?(COMMENT_RE)

        line = t[0][0]
        r[line] = comment
      end

      r
    end

    ##
    # Helper

    # @param [String] message
    # @return [void]
    def debug_print!(message)
      print "#{message}\n" if @debug
    end

    # @param [String] p
    # @return [AST::PTypeNode]
    def type_node(p)
      if @p_types[p]
        @p_types[p]
      else
        AST::PTypeNode.new(
          p_type: ANY_TYPE,
          p_name: p,
          kind:   AST::PTypeNode::KIND[:normal],
        )
      end
    end

    # @param [String] p
    # @return [AST::PTypeNode]
    def block_type_node(p)
      if @p_types[p]
        @p_types[p]
      else
        AST::PTypeNode.new(
          p_type: ANY_BLOCK_TYPE,
          p_name: p,
          kind:   AST::PTypeNode::KIND[:block],
        )
      end
    end

    # @param [String] type
    # @return [String]
    def normalize_type(type)
      debug_print! type
      Type.translate(type)
    end
  end
end
