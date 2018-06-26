class MyClass
  def self.name: -> String
  def name: -> String
  def pair: -> Array<Symbol>
  def type: -> Array<Symbol | Integer>
  def opts: -> Hash<any, any>
  def values: (?off: Integer) -> Hash<Symbol, Integer | nil>
  def reverse: (Array<Integer>, order: Symbol) -> Array<Integer>
  def first!: (any) -> any
end
module MyClass::InnerClass
  def double: (source: Integer) -> Integer
end
