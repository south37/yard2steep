class Yard2steep::Type::TypeBase
  def self.union2s: (Array<TypeBase>) -> String
end
class Yard2steep::Type::AnyType <: Yard2steep::Type::TypeBase
  def to_s: -> any
end
class Yard2steep::Type::NormalType <: Yard2steep::Type::TypeBase
  def initialize: (type: String) -> any
  def to_s: -> any
end
class Yard2steep::Type::ArrayType <: Yard2steep::Type::TypeBase
  def initialize: (type: Array<TypeBase>) -> any
  def to_s: -> any
end
class Yard2steep::Type::HashType <: Yard2steep::Type::TypeBase
  def initialize: (key: Array<TypeBase>, val: Array<TypeBase>) -> any
  def to_s: -> any
end
