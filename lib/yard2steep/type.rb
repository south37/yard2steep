require 'strscan'
require 'yard2steep/type/ast'
require 'yard2steep/type/parser'

module Yard2steep
  class Type
    # @param [Strng]
    # @return [String]
    def self.translate(text)
      Type.new(text).translate
    end

    # @param [String] text
    def initialize(text)
      @text = text
    end

    def translate
      tokens = tokens(@text)
      ast = Parser.parse(tokens)
      TypeBase.union2s(ast)
    end

    S_RE = /[\s\t]*/
    TOKENS = /
      [<>(),|={}]|[\w:]+
    /x

    # @param [String] str
    # @return [Array<String>]
    def tokens(str)
      r = []
      s = StringScanner.new(str)
      while !s.eos?
        s.scan(S_RE)
        r.push(s.scan(TOKENS))
      end
      r
    end
  end
end
