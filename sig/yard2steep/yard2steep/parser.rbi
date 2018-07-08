class Yard2steep::Parser
  def initialize: -> any
  def parse: (String, String, ?debug: bool) -> AST::ClassNode
  def parse_program: (String) -> void
  def parse_stmts: (Array<any>) -> void
  def parse_stmt: (Array<any>) -> void
  def parse_defs: (Array<any>) -> void
  def parse_def: (Array<any>) -> void
  def parse_method_impl: (String, Integer, Array<any>) -> void
  def extract_p_types!: (Integer) -> void
  def parse_comment!: (String) -> void
  def try_param_comment: (String) -> bool
  def try_return_comment: (String) -> bool
  def parse_params: (Array<any>) -> Array<AST::PNode>
  def parse_paren_params: (Array<any>) -> Array<AST::PNode>
  def parse_no_paren_params: (Array<any>) -> Array<AST::PNode>
  def within_context: { (any) -> any } -> void
  def parse_class_or_module: (Array<any>) -> void
  def parse_bodystmt: (Array<any>) -> void
  def parse_assign: (Array<any>) -> void
  def parse_command: (Array<any>) -> void
  def parse_command_args_add_block: (Array<any>) -> Array<String>
  def parse_method_add_arg: (Array<any>) -> void
  def parse_attr_reader: (any) -> void
  def extract_comments: (String) -> Hash<String, String>
  def debug_print!: (String) -> void
  def type_node: (String) -> AST::PTypeNode
  def block_type_node: (String) -> AST::PTypeNode
  def normalize_type: (String) -> String
end
Yard2steep::Parser::S_RE: any
Yard2steep::Parser::TYPE_WITH_PAREN_RE: any
Yard2steep::Parser::COMMENT_RE: any
Yard2steep::Parser::PARAM_RE: any
Yard2steep::Parser::RETURN_RE: any
Yard2steep::Parser::ANY_TYPE: any
Yard2steep::Parser::ANY_BLOCK_TYPE: any
