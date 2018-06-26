module Yard2steep
  module Util
    class AssertError < RuntimeError; end

    def self.assert!
      raise AssertError.new("Assertion failed!") if !yield
    end
  end
end
