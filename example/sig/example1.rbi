class MyClass
  def name: -> String
  def reverse: (String, order: Symbol) -> String
  def first: (any) -> any
end
module MyClass::InnerClass
  def double: (source: Integer) -> Integer
end
