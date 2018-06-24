require 'yard2steep/util'

module Yard2steep
  class Gen
    def initialize
      @out = StringIO.new('')  # Output buffer
    end

    def gen(ast)
      gen_c!(ast, off: 0)

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

    def gen_c!(c_node, off:)
      Util.assert! { c_node.is_a?(ClassNode) }

      # TODO(south37) We should check `main` by class_node's type (not name).
      if c_node.c_name == 'main'
        # NOTE: In main, steep does not check method type, so we does not
        # generate type definition of methods.
        gen_c_list!(c_node, off: 0)
      else
        emit! "#{c_node.kind} #{c_node.long_name}\n", off: off
        gen_m_list!(c_node, off: off + 2)
        emit! "end\n", off: off
        gen_c_list!(c_node, off: off)
      end
    end

    def gen_m_list!(c_node, off:)
      c_node.m_list.each do |m_node|
        gen_m!(m_node, off: off)
      end
    end

    def gen_c_list!(c_node, off:)
      c_node.children.each do |c_node|
        gen_c!(c_node, off: off)
      end
    end

    def gen_m!(m_node, off:)
      Util.assert! { m_node.is_a?(MethodNode) }
      emit! "def #{m_node.m_name}: ", off: off
      len = m_node.p_list.size
      if len > 0
        emit! "("

        m_node.p_list.each.with_index do |p, i|
          gen_m_p!(p)
          if i < (len - 1)
            emit!(", ")
          end
        end

        emit! ") "
      end
      emit! "-> #{m_node.r_type}\n"
    end

    def gen_m_p!(p_node)
      t = p_node.type_node

      case p_node.style
      when PNode::STYLE[:normal]
        emit! t.p_type
      when PNode::STYLE[:keyword]
        emit! "#{t.p_name}: #{t.p_type}"
      else
        raise "invalid style: #{p_node.style}"
      end
    end
  end
end
