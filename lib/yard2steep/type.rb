require 'strscan'
require 'yard2steep/type/ast'
require 'yard2steep/type/parser'

module Yard2steep
  class Type
    # @param [String] text
    # @return [String]
    def self.translate(text)
      Type.new(text).translate
    end

    # @param [String] text
    def initialize(text)
      @text = text
    end

    # @return [String]
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
      while true
        s.scan(S_RE)
        break if s.eos?
        if t = s.scan(TOKENS)
          r.push(t)
        else
          raise "token must exist!"
        end
      end
      r
    end
  end
end
