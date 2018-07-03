module Yard2steep
  module Util
    class AssertError < RuntimeError; end

    # @return [void]
    def self.assert!(&block)
      raise AssertError.new("Assertion failed!") if !block.call
    rescue AssertError => e
      # NOTE: Enable when debug option is true
      # print e
      # code = <<-CODE
      #   require 'pry'
      #   binding.pry
      # CODE
      # eval(code, block.binding)
      raise e
    end
  end
end
