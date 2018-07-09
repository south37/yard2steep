module Yard2steep
  class Type
    class TypeBase
      def to_s
        raise "Must be implemented in child class"
      end
    end

    class AnyType < TypeBase
      # @return [String]
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
      # @param [TypeBase] type
      def initialize(type:)
        @type = type
      end

      # @return [String]
      def to_s
        "Array<#{@type}>"
      end
    end

    class HashType < TypeBase
      # @param [TypeBase] key
      # @param [TypeBase] val
      def initialize(key:, val:)
        @key = key
        @val = val
      end

      # @return [String]
      def to_s
        "Hash<#{@key}, #{@val}>"
      end
    end

    class UnionType < TypeBase
      def initialize(types:)
        Util.assert! { types.size > 0 }
        @types = types
      end

      # @return [String]
      def to_s
        @types.map { |t| t.to_s }.uniq.join(' | ')
      end
    end
  end
end
