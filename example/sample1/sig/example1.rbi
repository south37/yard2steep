class MyClass
  @index: any
  def index: -> any
  def self.name: -> String
  def name: -> String
  def pair: -> Array<Symbol>
  def type: -> Array<Symbol | Integer>
  def opts: -> Hash<any, any>
  def values: (?off: Integer) -> Hash<Symbol, Integer | nil>
  def reverse: (Array<Integer>, order: Symbol) -> Array<Integer>
  def first!: (any) -> any
  def present?: (any) -> any
  def mysum: (any) { (any) -> any } -> any
end
MyClass::CONSTANT: any
module MyClass::InnerClass
  def double: (source: Integer) -> Integer
end
class OtherClass
  def yes: -> any
end
