module Yard2steep
  class Engine
    # @param [String] file
    # @param [String] text
    # @param [bool] debug
    # @param [bool] debug_ast
    # @return [String]
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
