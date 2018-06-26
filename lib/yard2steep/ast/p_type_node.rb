module Yard2steep
  module AST
  # PTypeNode represents `parameter` AST.
    class PTypeNode
      attr_accessor :p_type, :p_name

      def initialize(p_type:, p_name:)
        Util.assert! { p_type.is_a?(String) }
        Util.assert! { p_name.is_a?(String) }
        @p_type = p_type
        @p_name = p_name
      end
    end
  end
end
