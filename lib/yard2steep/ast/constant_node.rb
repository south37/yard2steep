module Yard2steep
  module AST
    class ConstantNode
      attr_accessor :name, :klass

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
