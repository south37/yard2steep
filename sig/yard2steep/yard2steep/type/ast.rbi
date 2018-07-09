class Yard2steep::Type::TypeBase
  def to_s: -> any
end
class Yard2steep::Type::AnyType <: Yard2steep::Type::TypeBase
  def to_s: -> String
end
class Yard2steep::Type::NormalType <: Yard2steep::Type::TypeBase
  def initialize: (type: String) -> any
  def to_s: -> any
end
class Yard2steep::Type::ArrayType <: Yard2steep::Type::TypeBase
  def initialize: (type: TypeBase) -> any
  def to_s: -> String
end
class Yard2steep::Type::HashType <: Yard2steep::Type::TypeBase
  def initialize: (key: TypeBase, val: TypeBase) -> any
  def to_s: -> String
end
class Yard2steep::Type::UnionType <: Yard2steep::Type::TypeBase
  def initialize: (types: any) -> any
  def to_s: -> String
end
