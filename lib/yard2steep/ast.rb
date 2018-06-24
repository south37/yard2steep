module Yard2steep
  # ClassNode represents `Class` or `Module` AST.
  class ClassNode
    attr_accessor :c_name, :m_list, :children, :parent

    def initialize(c_name:, parent:)
      Util.assert! { c_name.is_a?(String) }
      Util.assert! { parent.is_a?(ClassNode) || (parent.nil? && c_name == 'main') }
      @c_name   = c_name
      @m_list   = []
      @children = []
      @parent   = parent
    end

    def append_m(m)
      @m_list.push(m)
    end

    def append_child(child)
      @children.push(child)
    end

    def long_name
      @long_name ||= begin
         # NOTE: main has no long_name
         if @c_name == 'main'
           ''
         elsif @parent.c_name == 'main'
           @c_name
         else
           "#{@parent.long_name}::#{@c_name}"
         end
      end
    end
  end

  ClassNode::Main = ClassNode.new(c_name: 'main', parent: nil)

  # MethodNode represents `method` AST.
  class MethodNode
    attr_accessor :p_list, :r_type, :m_name

    def initialize(m_name:, p_list:, r_type:)
      Util.assert! { m_name.is_a?(String) }
      Util.assert! { p_list.is_a?(Array) }
      Util.assert! { r_type.is_a?(String) }
      @p_list = p_list
      @r_type = r_type
      @m_name = m_name
    end
  end

  # ParamNode represents `parameter` AST.
  class ParamNode
    attr_accessor :p_type, :p_name

    def initialize(p_type:, p_name:)
      # TODO(south37) if p_type is nil, Use `Any` type
      Util.assert! { p_name.is_a?(String) }
      @p_type = p_type
      @p_name = p_name
    end
  end
end
