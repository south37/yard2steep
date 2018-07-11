module Yard2steep
  module AST
    class ConstantNode
      # @dynamic name, klass, v_type
      attr_reader :name, :klass, :v_type

      # @param [String] name
      # @param [String] klass
      # @param [String] v_type
      def initialize(name:, klass:, v_type:)
        Util.assert! { name.is_a?(String) }
        @name   = name
        @klass  = klass
        @v_type = v_type
      end

      # @return [String]
      def long_name
        "#{@klass.long_name}::#{@name}"
      end
    end
  end
end
