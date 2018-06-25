module Yard2steep
  class Engine
    class << self
      def execute(file, text)
        ast = Parser.new.parse(file, text)
        Gen.new.gen(ast)
      end
    end
  end
end
