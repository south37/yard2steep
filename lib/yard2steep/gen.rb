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
        gen_c_body!(c_node, off: 0)
      else
        emit! "class #{c_node.c_name}\n", off: off
        gen_c_body!(c_node, off: off + 2)
        emit! "end\n", off: off
      end
    end

    def gen_c_body!(c_node, off:)
      c_node.m_list.each do |m_node|
        gen_m!(m_node, off: off)
      end
      c_node.children.each do |c_node|
        gen_c!(c_node, off: off)
      end
    end

    def gen_m!(m_node, off:)
      Util.assert! { m_node.is_a?(MethodNode) }
      emit! "def #{m_node.m_name}: ", off: off
      if m_node.p_list.size > 0
        emit! "("
        emit! m_node.p_list.map { |h| "#{h.p_name}: #{h.p_type}" }.join(", ")
        emit! ") "
      end
      emit! "-> #{m_node.r_type}\n"
    end
  end
end
