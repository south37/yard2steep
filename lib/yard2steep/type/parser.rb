module Yard2steep
  class Type
    class Parser
      # @param [Array<String>] tokens
      # @return [Array<TypeBase>]
      def self.parse(tokens)
        Parser.new(tokens).parse
      end

      # @param [Array<String>] tokens
      def initialize(tokens)
        @tokens = tokens
        @types  = []
      end

      # @reutrn [Array<TypeBase>]
      def parse
        debug_print!(@tokens)

        return [] if (@tokens.size == 0)

        @types.push(parse_type)
        while @tokens.size > 0
          expect!(',')
          @types.push(parse_type)
        end

        UnionType.new(types: @types)
      end

    private

      # @return [TypeBase]
      def parse_type
        t = get
        Util.assert! { t }

        case t
        when 'Array'
          r = parse_array
        when 'Hash'
          r = parse_hash
        else
          r = parse_normal_type(t)
        end

        debug_print! "type: #{r}\n"
        debug_print! "peek: #{peek}\n"

        r
      end

      # @param [String] t
      # @return [NormalType]
      def parse_normal_type(t)
        NormalType.new(type: t)
      end

      # @param [String] term_s
      # @return [Array<TypeBase>]
      def parse_multiple_types(term_s)
        t = peek
        if t == term_s
          expect!(term_s)
          return []
        end

        r = []
        r.push(parse_type)

        while t = peek
          break unless t == ','
          expect!(',')
          r.push(parse_type)
        end

        debug_print! "term_s: #{term_s}\n"
        expect!(term_s)

        r
      end

      # @return [ArrayType]
      def parse_array
        case peek
        when '<'
          expect!('<')
          type = UnionType.new(
            types: parse_multiple_types('>')
          )
        when '('
          expect!('(')
          type = UnionType.new(
            types: parse_multiple_types(')')
          )
        else
          type = AnyType.new
        end

        ArrayType.new(type: type)
      end

      # @return [HashType]
      def parse_hash
        debug_print!("parse_hash, peek: #{peek}")

        case peek
        when '{'
          expect!('{')
          key = UnionType.new(types: parse_multiple_types('='))
          expect!('>')
          val = UnionType.new(types: parse_multiple_types('}'))

          HashType.new(
            key: key,
            val: val,
          )
        else
          HashType.new(
            key: AnyType.new,
            val: AnyType.new,
          )
        end
      end

      # @param [String] token
      def expect!(token)
        t = get
        Util.assert! { t == token }
      end

      # @return [String]
      def get
        @tokens.shift
      end

      # @return [String]
      def peek
        @tokens[0]
      end

      # @param [String] message
      # @return [void]
      def debug_print!(message)
        # TODO(south37) Add flag
        # print message
      end
    end
  end
end
