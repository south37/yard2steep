module Yard2steep
  module Util
    class << self
      class AssertError < RuntimeError; end

      def assert!(&block)
        raise AssertError.new("Assertion failed!") if !block.call
      end
    end
  end
end
