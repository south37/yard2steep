module Yard2steep
  module AST
    # AST::ClassNode represents `Class` or `Module` AST.
    class ClassNode
      attr_accessor :kind, :c_name, :m_list, :children, :parent

      KIND = ['class', 'module']

      def initialize(kind:, c_name:, parent:)
        Util.assert! { KIND.include?(kind) }
        Util.assert! { c_name.is_a?(String) }
        Util.assert! { parent.is_a?(AST::ClassNode) || (parent.nil? && c_name == 'main') }
        @kind     = kind
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

    AST::ClassNode::Main = AST::ClassNode.new(kind: 'module', c_name: 'main', parent: nil)
  end
end
