module Yard2steep
  module AST
    class ConstantNode
      # @dynamic name, klass
      attr_reader :name, :klass

      def initialize(name:, klass:)
        Util.assert! { name.is_a?(String) }
        @name  = name
        @klass = klass
      end

      def long_name
        "#{@klass.long_name}::#{@name}"
      end
    end
  end
end
