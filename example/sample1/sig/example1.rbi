class SomeClass
  @index: any
  @comment: any
  @count: any
  def index: -> any
  def index=: (any) -> any
  def comment: -> any
  def count: -> any
  def count=: (any) -> any
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
MyClass::CONSTANT: String
MyClass::CONSTANT2: Regexp
MyClass::CONSTANT3: Symbol
MyClass::CONSTANT4: Range<any>
MyClass::CONSTANT5: Integer
MyClass::CONSTANT6: Float
MyClass::CONSTANT7: Array<any>
MyClass::CONSTANT8: Hash<any, any>
MyClass::CONSTANT9: bool
MyClass::CONSTANT10: bool
MyClass::CONSTANT11: nil
module MyClass::InnerClass
  def double: (source: Integer) -> Integer
end
class OtherClass <: MyClass
  def yes: -> any
end
