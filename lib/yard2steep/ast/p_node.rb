module Yard2steep
  module AST
    class PNode
      attr_accessor :type_node, :style

      STYLE = {
        normal:  "STYLE.normal",
        keyword: "STYLE.keyword",
      }

      def initialize(type_node:, style:)
        Util.assert! { type_node.is_a?(AST::PTypeNode) }
        Util.assert! { STYLE.values.include?(style) }
        @type_node = type_node
        @style     = style
      end
    end
  end
end
