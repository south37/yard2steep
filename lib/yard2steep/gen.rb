require 'yard2steep/util'

module Yard2steep
  class Gen
    def initialize
      @out = StringIO.new # Output buffer
    end

    def gen(ast)
      gen_child!(ast, off: 0)

      @out.rewind
      @out.read
    end

    def emit!(s, off: 0)
      Util.assert! { off >= 0 }
      if off == 0
        @out.print(s)
      else
        @out.print("#{' ' * off}#{s}")
      end
    end

    def gen_child!(c_node, off:)
      Util.assert! { c_node.is_a?(AST::ClassNode) }

      # TODO(south37) We should check `main` by class_node's type (not name).
      if c_node.c_name == 'main'
        # NOTE: In main, steep does not check method type, so we does not
        # generate type definition of methods.
        gen_children!(c_node, off: 0)
      else
        if (c_node.m_list.size > 0) || (c_node.ivar_list.size > 0)
          emit! "#{c_node.kind} #{c_node.long_name}\n", off: off
          gen_ivar_list!(c_node, off: off + 2)
          gen_m_list!(c_node, off: off + 2)
          emit! "end\n", off: off
        end
        gen_c_list!(c_node, off: off)
        gen_children!(c_node, off: off)
      end
    end

    def gen_m_list!(c_node, off:)
      c_node.m_list.each do |m_node|
        gen_m!(m_node, off: off)
      end
    end

    # NOTE: In current impl, ivar's type is declared as any
    def gen_ivar_list!(c_node, off:)
      c_node.ivar_list.each do |ivar_node|
        emit! "@#{ivar_node.name}: any\n", off: off
      end
    end

    def gen_c_list!(c_node, off:)
      c_node.c_list.each do |c_node|
        gen_c!(c_node, off: off)
      end
    end

    def gen_children!(c_node, off:)
      c_node.children.each do |child|
        gen_child!(child, off: off)
      end
    end

    def gen_c!(c_node, off:)
      Util.assert! { c_node.is_a?(AST::ConstantNode) }
      # NOTE: Use any as constant type.
      emit! "#{c_node.long_name}: any\n", off: off
    end

    def gen_m!(m_node, off:)
      Util.assert! { m_node.is_a?(AST::MethodNode) }
      emit! "def #{m_node.m_name}: ", off: off
      p_list = m_node.p_list

      # NOTE: Check presence of block variable at last.
      if p_list[-1] && (p_list[-1].type_node.kind == AST::PTypeNode::KIND[:block])
        gen_p_list!(p_list[0..-2])
        gen_block_p!(p_list[-1])
      else
        gen_p_list!(p_list)
      end

      emit! "-> #{m_node.r_type}\n"
    end

    def gen_p_list!(p_list)
      len = p_list.size
      if len > 0
        emit! "("

        p_list.each.with_index do |p, i|
          gen_m_p!(p)
          if i < (len - 1)
            emit!(", ")
          end
        end

        emit! ") "
      end
    end

    # TODO(south37) Represents block param and return type separately
    def gen_block_p!(p)
      emit! "#{p.type_node.p_type} "
    end

    def gen_m_p!(p_node)
      t = p_node.type_node

      case p_node.style
      when AST::PNode::STYLE[:normal]
        emit! t.p_type
      when AST::PNode::STYLE[:keyword]
        emit! "#{t.p_name}: #{t.p_type}"
      when AST::PNode::STYLE[:keyword_with_default]
        emit! "?#{t.p_name}: #{t.p_type}"
      else
        raise "invalid style: #{p_node.style}"
      end
    end
  end
end
