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
  # NOTE: method definition in singleton class should be ignored
  class << self
    # @return [String]
    def ok
      'ok'
    end
  end

  # @return [String]
  def name
    'name'
  end

  # @param [String] contents
  # @param [Symbol] order
  # @return [String]
  def reverse contents, order:
    if order == :normal
      return ''
    end

    case order
    when :other then return ''
    else
      raise "invalid"
    end
    # .
    # .
    # .
    # NOTE: this is wrong comment. so should ignore it
    # @param [Array] contents
    ''
  end

  # NOTE: should be interpreterd as any -> any
  def first(list)
    list.last
  end

  module InnerClass
    # @param [Integer] source
    # @return [Integer]
    def double(source:); source * 2; end
  end
end
