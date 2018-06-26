module Yard2steep
  class Engine
    class << self
      def execute(file, text, debug: false)
        ast = Parser.new.parse(file, text, debug: debug)
        Gen.new.gen(ast)
      end
    end
  end
end
