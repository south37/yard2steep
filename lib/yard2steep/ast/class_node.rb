module Yard2steep
  module AST
    # AST::ClassNode represents `Class` or `Module` AST.
    class ClassNode
      def self.create_main
        AST::ClassNode.new(
          kind:   'module',
          c_name: 'main',
          parent: nil,
        )
      end

      # @dynamic kind, c_name, c_list, m_list, ivar_list, children, parent
      attr_reader :kind, :c_name, :c_list, :m_list, :ivar_list, :children, :parent

      KIND = ['class', 'module']

      def initialize(kind:, c_name:, parent:)
        Util.assert! { KIND.include?(kind) }
        Util.assert! { c_name.is_a?(String) }
        Util.assert! {
          parent.is_a?(AST::ClassNode) ||
          (parent.nil? && c_name == 'main')
        }
        @kind      = kind
        @c_name    = c_name
        @c_list    = []  # list of constants
        @m_list    = []  # list of methods
        @ivar_list = []  # list of instance variables
        @children  = []  # list of child classes
        @parent    = parent
      end

      def append_constant(c)
        @c_list.push(c)
      end

      def append_m(m)
        @m_list.push(m)
      end

      def append_ivar(ivar)
        @ivar_list.push(ivar)
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

      def to_s
        inspect
      end

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
