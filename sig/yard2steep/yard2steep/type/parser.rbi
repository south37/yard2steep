class Yard2steep::Type::Parser
  def self.parse: (any) -> Array<TypeBase>
  def initialize: (any) -> any
  def parse: -> any
  def parse_type: -> TypeBase
  def parse_normal_type: (String) -> NormalType
  def parse_multiple_types: (String) -> Array<TypeBase>
  def parse_array: -> ArrayType
  def parse_hash: -> any
  def expect!: (String) -> any
  def get: -> any
  def peek: -> any
  def debug_print!: (String) -> any
end
