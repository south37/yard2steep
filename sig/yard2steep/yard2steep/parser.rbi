class Yard2steep::Parser
  def initialize: -> any
  def parse: (String, String, ?debug: bool) -> AST::ClassNode
  def reset_method_context!: -> void
  def parse_line: (String) -> void
  def try_parse_comment: (String) -> bool
  def try_parse_param_or_return: (String) -> bool
  def try_parse_end: (String) -> bool
  def try_parse_postfix_if: (String) -> bool
  def try_parse_begin_end: (String) -> bool
  def try_parse_class: (String) -> bool
  def try_parse_constant: (String) -> bool
  def try_parse_singleton_class: (String) -> bool
  def try_parse_param: (String) -> bool
  def try_parse_return: (String) -> bool
  def try_parse_method: (String) -> bool
  def try_parse_method_with_no_action: (String) -> bool
  def parse_method_params: (String) -> Array<AST::PNode>
  def try_parse_attr: (String) -> bool
  def push_state!: (String) -> void
  def pop_state!: -> void
  def stack_is_empty?: -> bool
  def type_node: (String) -> AST::PTypeNode
  def debug_print!: (String, ?offset: Integer) -> void
  def normalize_type: (String) -> String
  def normalize_multi_type: (String) -> String
end
Yard2steep::Parser::S_RE: any
Yard2steep::Parser::S_P_RE: any
Yard2steep::Parser::PRE_RE: any
Yard2steep::Parser::POST_RE: any
Yard2steep::Parser::CLASS_RE: any
Yard2steep::Parser::MODULE_RE: any
Yard2steep::Parser::S_CLASS_RE: any
Yard2steep::Parser::END_RE: any
Yard2steep::Parser::CONSTANT_ASSIGN_RE: any
Yard2steep::Parser::POSTFIX_IF_RE: any
Yard2steep::Parser::BEGIN_END_RE: any
Yard2steep::Parser::COMMENT_RE: any
Yard2steep::Parser::TYPE_WITH_PAREN_RE: any
Yard2steep::Parser::PARAM_RE: any
Yard2steep::Parser::RETURN_RE: any
Yard2steep::Parser::PAREN_RE: any
Yard2steep::Parser::ARGS_RE: any
Yard2steep::Parser::METHOD_RE: any
Yard2steep::Parser::ATTR_RE: any
Yard2steep::Parser::STATES: any
Yard2steep::Parser::ANY_TYPE: any
Yard2steep::Parser::ANY_BLOCK_TYPE: any
Yard2steep::Parser::ARRAY_TYPE_RE: any
Yard2steep::Parser::FIXED_ARRAY_TYPE_RE: any
Yard2steep::Parser::HASH_TYPE_RE: any
