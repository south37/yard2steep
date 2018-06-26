module Yard2steep
  module AST
    # MethodNode represents `method` AST.
    class MethodNode
      attr_accessor :p_list, :r_type, :m_name

      def initialize(m_name:, p_list:, r_type:)
        Util.assert! { m_name.is_a?(String) }
        Util.assert! { p_list.is_a?(Array) }
        Util.assert! { r_type.is_a?(String) }
        @p_list = p_list
        @r_type = r_type
        @m_name = m_name
      end
    end
  end
end
