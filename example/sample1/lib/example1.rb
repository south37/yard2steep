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

class SomeClass
  # @dynamic index, comment
  attr_reader :index
  attr_reader("comment")
end

module SomeModule
end

class MyClass
  # NOTE: method definition in singleton class should be ignored
  class << self
    # @return [String]
    def ok
      return 'no' if true
      'ok'
    end
  end

  CONSTANT   = "This is constant"
  CONSTANT2  = /this is re/
  CONSTANT3  = :symbol_value
  CONSTANT4  = 1..2
  CONSTANT5  = 34
  CONSTANT6  = 2.34
  CONSTANT7  = [1, 2]
  CONSTANT8  = { a: 3 }
  CONSTANT9  = true
  CONSTANT10 = false
  CONSTANT11 = nil

  # This for should not be used.
  # @return [String]
  def self.name
    'name'
  end

  # @return [String]
  def name
    'name'
  end

  # @return [Array(Symbol, Symbol)]
  def pair
    [:ok, :no]
  end

  # @return [Array<Array<Symbol>>]
  def nest
    [[:o]]
  end

  # @return [Array(Symbol, Integer)]
  def type
    [:number, 1]
  end

  # @return [Hash]
  def opts
    {}
  end

  # @param [String] base
  # @param [Integer] off
  # @param [Hash] opt
  # @return [String]
  def comment(base, off = 0, opt: {})
    ""
  end

  # @param [Integer] off
  # @return [Hash{ Symbol => Integer, nil }]
  def values(off: 0)
    { ok: 3, no: nil }
  end

  # @return [Hash{ Symbol => Array<Integer> }]
  def nest_hash
    { ok: [1, 2] }
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

  # NOTE: Args after default args is not supported by steep.
  # # @param [String] str
  # # @param [Integer] id
  # # @param [Array] rest
  # def setup(str, id = 1, rest)
  # end

  # NOTE: should be interpreterd as any -> any
  def present?(list)
    list.size > 0
  end

  def mysum(list, &block)
    list.map { |e| block.call(e) }.inject(&:+)
  end

  module InnerClass
    # @param [Integer] source
    # @return [Integer]
    def double(source:); source * 2; end
  end
end

class OtherClass < MyClass
  def yes
    'yes'
  end
end
