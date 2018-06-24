# NOTE: only for debug
# TODO(south37) Remove after development
require 'pry'

require 'yard2steep/util'
require 'yard2steep/parser'
require 'yard2steep/gen'
require "yard2steep/version"

module Yard2steep
  class Engine
    class << self
      def execute(file)
        self.new.execute(file)
      end
    end

    def execute(file)
      text = File.read(file)
      ast = Parser.new.parse(text)
      Gen.new.gen(ast)
    end
  end
end

## test
expected = <<EOF
def first: (contents: Array) -> Symbol
class MyClass
  def reverse: (contents: String, order: Symbol) -> String
  class InnerClass
    def sort: (contents: Array) -> Array
  end
end
EOF
got = Yard2steep::Engine.execute('./source/sample.rb')
if got != expected
  print "expected: "
  p expected
  print "got: "
  p got
end
print got
