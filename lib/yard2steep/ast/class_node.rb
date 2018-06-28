module Yard2steep
  module AST
    # AST::ClassNode represents `Class` or `Module` AST.
    class ClassNode
      # @return [AST::ClassNode]
      def self.create_main
        AST::ClassNode.new(
          kind:   'module',
          c_name: 'main',
          super_c: nil,
          parent:  nil,
        )
      end

      # @dynamic kind, c_name, super_c, c_list, m_list, ivar_list, children, parent
      attr_reader :kind, :c_name, :super_c, :c_list, :m_list, :ivar_list, :children, :parent

      KIND = ['class', 'module']

      # @param [String] kind
      # @param [String] c_name
      # @param [AST::ClassNode, nil] parent
      # @param [String, nil] super_c
      def initialize(kind:, c_name:, super_c:, parent:)
        Util.assert! { KIND.include?(kind) }
        Util.assert! { c_name.is_a?(String) }
        Util.assert! {
          parent.is_a?(AST::ClassNode) ||
          (parent == nil && c_name == 'main')
        }
        @kind      = kind
        @c_name    = c_name
        @super_c   = super_c
        @c_list    = []  # list of constants
        @m_list    = []  # list of methods
        @ivar_list = []  # list of instance variables
        @children  = []  # list of child classes
        @parent    = parent
      end

      # @param [AST::ConstantNode] c
      # @return [void]
      def append_constant(c)
        @c_list.push(c)
      end

      # @param [AST::MethodNode] m
      # @return [void]
      def append_m(m)
        @m_list.push(m)
      end

      # @param [AST::IVarNode] ivar
      # @return [void]
      def append_ivar(ivar)
        @ivar_list.push(ivar)
      end

      # @param [AST::ClassNode] child
      # @return [void]
      def append_child(child)
        @children.push(child)
      end

      # @return [String]
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

      def long_super
        @long_super ||= begin
           if @parent.c_name == 'main'
             @super_c
           else
             "#{@parent.long_name}::#{@super_c}"
           end
        end
      end

      # @return [String]
      def to_s
        inspect
      end

      # @return [String]
      def inspect
        <<-EOF
{
  #{@kind}: #{c_name},
  c_list: [#{@c_list.map(&:to_s).map { |s| "#{s}\n" }.join}],
  m_list: [#{@m_list.map(&:to_s).map { |s| "#{s}\n" }.join}],
  ivar_list: [#{@ivar_list.map(&:to_s).map { |s| "#{s}\n" }.join}],
  children: [#{@children.map(&:to_s).map { |s| "#{s}\n" }.join}],
}
        EOF
      end
    end
  end
end
