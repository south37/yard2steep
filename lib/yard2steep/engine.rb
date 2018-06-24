module Yard2steep
  class Engine
    class << self
      def execute(text)
        ast = Parser.new.parse(text)
        Gen.new.gen(ast)
      end
    end
  end
end
