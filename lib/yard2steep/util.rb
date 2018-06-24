module Yard2steep
  module Util
    class << self
      class AssertError < RuntimeError; end

      def assert!(&block)
        raise AssertError.new("Assertion failed!") if !block.call
      rescue AssertError => e
        print e
        code = <<-CODE
          require 'pry'
          binding.pry
        CODE
        eval(code, block.binding)
      end
    end
  end
end
