# @param [Array] contents
# @return [Symbol]
def first(contents:)
  # .
  # .
  # .
  # NOTE: this is wrong comment. so should ignore it
  # @param [Array] contents
  []
end

# NOTE: this is wrong comment. so should ignore it
# @param [Array] contents

class MyClass
  # @return [String]
  def name
    'name'
  end

  # @param [String] contents
  # @param [Symbol] order
  # @return [String]
  def reverse contents, order:
    # .
    # .
    # .
    # NOTE: this is wrong comment. so should ignore it
    # @param [Array] contents
    ''
  end

  module InnerClass
    # @param [Integer] source
    # @return [Integer]
    def double(source:); source * 2; end
  end
end
