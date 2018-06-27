module Yard2steep
  module AST
    class PNode
      # @dynamic type_node, style
      attr_reader :type_node, :style

      STYLE = {
        normal:               "STYLE.normal",
        keyword:              "STYLE.keyword",
        keyword_with_default: "STYLE.keyword_with_default",
      }

      # @param [AST::PTypeNode] type_node
      # @param [String] style
      def initialize(type_node:, style:)
        Util.assert! { type_node.is_a?(AST::PTypeNode) }
        Util.assert! { STYLE.values.include?(style) }
        @type_node = type_node
        @style     = style
      end
    end
  end
end
