module Yard2steep
  module AST
  # PTypeNode represents `parameter` AST.
    class PTypeNode
      # @dynamic p_type, p_name, kind
      attr_reader :p_type, :p_name, :kind

      KIND = {
        normal: "KIND.normal",
        block:  "KIND.block",
      }

      def initialize(p_type:, p_name:, kind:)
        Util.assert! { p_type.is_a?(String) }
        Util.assert! { p_name.is_a?(String) }
        Util.assert! { KIND.values.include?(kind) }
        @p_type = p_type
        @p_name = p_name
        @kind   = kind
      end
    end
  end
end
