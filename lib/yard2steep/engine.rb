module Yard2steep
  class Engine
    def self.execute(file, text, debug: false, debug_ast: false)
      if debug
        print "## execute\n"
        print "  file: #{file}\n"
      end

      ast = Parser.new.parse(file, text, debug: debug)

      if debug_ast
        print "  ast: #{ast}\n\n"
      end

      Gen.new.gen(ast)
    end
  end
end
