class Yard2steep::Gen
  def initialize: -> any
  def gen: (AST::ClassNode) -> String
  def emit!: (String, ?off: Integer) -> void
  def gen_child!: (AST::ClassNode, off: Integer) -> void
  def gen_m_list!: (AST::ClassNode, off: Integer) -> void
  def gen_ivar_list!: (AST::ClassNode, off: Integer) -> void
  def gen_c_list!: (AST::ClassNode, off: Integer) -> void
  def gen_children!: (AST::ClassNode, off: Integer) -> void
  def gen_c!: (AST::ConstantNode, off: Integer) -> void
  def gen_m!: (AST::MethodNode, off: Integer) -> void
  def gen_p_list!: (Array<AST::PNode>) -> void
  def gen_block_p!: (AST::PNode) -> void
  def gen_m_p!: (AST::PNode) -> void
end
