class Yard2steep::AST::ClassNode
  @kind: any
  @c_name: any
  @c_list: any
  @m_list: any
  @ivar_list: any
  @children: any
  @parent: any
  def self.create_main: -> any
  def kind: -> any
  def c_name: -> any
  def c_list: -> any
  def m_list: -> any
  def ivar_list: -> any
  def children: -> any
  def parent: -> any
  def initialize: (kind: any, c_name: any, parent: any) -> any
  def append_constant: (any) -> any
  def append_m: (any) -> any
  def append_ivar: (any) -> any
  def append_child: (any) -> any
  def long_name: -> any
  def to_s: -> any
  def inspect: -> any
end
Yard2steep::AST::ClassNode::KIND: any
