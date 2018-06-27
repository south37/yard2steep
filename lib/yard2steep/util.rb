module Yard2steep
  module Util
    class AssertError < RuntimeError; end

    # @param [{ () -> any }]
    # @return [void]
    def self.assert!(&block)
      raise AssertError.new("Assertion failed!") if !block.call
    end
  end
end
