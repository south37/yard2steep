module Yard2steep
  module AST
    # IVarNode represents `instance variable` AST.
    class IVarNode
      # @dynamic name
      attr_reader :name

      def initialize(name:)
        Util.assert! { name.is_a?(String) }
        @name = name
      end
    end
  end
end
