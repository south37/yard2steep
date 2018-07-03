class SomeClass
  @index: any
  @comment: any
  def index: -> any
  def comment: -> any
end
class MyClass
  def self.name: -> String
  def name: -> String
  def pair: -> Array<Symbol>
  def nest: -> Array<Array<Symbol>>
  def type: -> Array<Symbol | Integer>
  def opts: -> Hash<any, any>
  def comment: (String, ?Integer, ?opt: Hash<any, any>) -> String
  def values: (?off: Integer) -> Hash<Symbol, Integer | nil>
  def nest_hash: -> Hash<Symbol, Array<Integer>>
  def reverse: (Array<Integer>, order: Symbol) -> Array<Integer>
  def first!: (any) -> any
  def present?: (any) -> any
  def mysum: (any) { (any) -> any } -> any
end
MyClass::CONSTANT: any
module MyClass::InnerClass
  def double: (source: Integer) -> Integer
end
class OtherClass <: MyClass
  def yes: -> any
end
