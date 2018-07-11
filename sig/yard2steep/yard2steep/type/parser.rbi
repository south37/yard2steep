class Yard2steep::Type::Parser
  def self.parse: (Array<String>) -> Array<TypeBase>
  def initialize: (Array<String>) -> any
  def parse: -> any
  def parse_type: -> TypeBase
  def parse_normal_type: (String) -> NormalType
  def parse_multiple_types: (String) -> Array<TypeBase>
  def parse_array: -> ArrayType
  def parse_hash: -> HashType
  def expect!: (String) -> any
  def get: -> String
  def peek: -> String
  def debug_print!: (String) -> void
end
