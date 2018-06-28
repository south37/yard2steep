module Yard2steep
  class Type
    class TypeBase
      # @param [Array<TypeBase>] types
      # @return [String]
      def self.union2s(types)
        types.map { |t| t.to_s }.uniq.join(' | ')
      end
    end

    class AnyType < TypeBase
      def to_s
        'any'
      end
    end

    class NormalType < TypeBase
      # @param [String] type
      def initialize(type:)
        @type = type
      end

      def to_s
        @type
      end
    end

    class ArrayType < TypeBase
      # @param [Array<TypeBase>] type
      def initialize(type:)
        @type = type
      end

      def to_s
        "Array<#{TypeBase.union2s(@type)}>"
      end
    end

    class HashType < TypeBase
      # @param [Array<TypeBase>] key
      # @param [Array<TypeBase>] val
      def initialize(key:, val:)
        @key = key
        @val = val
      end

      def to_s
        "Hash<#{TypeBase.union2s(@key)}, #{TypeBase.union2s(@val)}>"
      end
    end
  end
end
