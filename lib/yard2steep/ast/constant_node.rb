module Yard2steep
  module AST
    class ConstantNode
      # @dynamic name, klass
      attr_reader :name, :klass

      # @param [String] name
      # @param [String] klass
      def initialize(name:, klass:)
        Util.assert! { name.is_a?(String) }
        @name  = name
        @klass = klass
      end

      # @return [String]
      def long_name
        "#{@klass.long_name}::#{@name}"
      end
    end
  end
end
