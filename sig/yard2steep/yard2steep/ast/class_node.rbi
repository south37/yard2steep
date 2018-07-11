class Yard2steep::AST::ClassNode
  @kind: any
  @c_name: any
  @super_c: any
  @c_list: any
  @m_list: any
  @ivar_list: any
  @children: any
  @parent: any
  def self.create_main: -> AST::ClassNode
  def kind: -> any
  def c_name: -> any
  def super_c: -> any
  def c_list: -> any
  def m_list: -> any
  def ivar_list: -> any
  def children: -> any
  def parent: -> any
  def initialize: (kind: String, c_name: String, super_c: String | nil, parent: AST::ClassNode | nil) -> any
  def append_constant: (AST::ConstantNode) -> void
  def append_m: (AST::MethodNode) -> void
  def append_ivar: (AST::IVarNode) -> void
  def append_child: (AST::ClassNode) -> void
  def long_name: -> String
  def long_super: -> any
  def to_s: -> String
  def inspect: -> String
end
Yard2steep::AST::ClassNode::KIND: Array<any>
