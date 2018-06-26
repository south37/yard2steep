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

  # @return [Array(Symbol, Symbol)]
  def pair
    [:ok, :no]
  end

  # @return [Array(Symbol, Integer)]
  def type
    [:number, 1]
  end

  # @return [Hash]
  def opts
    {}
  end

  # @return [Hash{ Symbol => Integer, nil }]
  def values
    { ok: 3, no: nil }
  end

  # @param [Array<Integer>] contents
  # @param [Symbol] order
  # @return [Array<Integer>]
  def reverse contents, order:
    if order == :normal
      return []
    end

    case order
    when :other then return []
    else
      raise "invalid"
    end
    # .
    # .
    # .
    # NOTE: this is wrong comment. so should ignore it
    # @param [Array] contents
    []
  end

  # NOTE: should be interpreterd as any -> any
  def first!(list)
    list.last
  end

  module InnerClass
    # @param [Integer] source
    # @return [Integer]
    def double(source:); source * 2; end
  end
end
