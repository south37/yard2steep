class Yard2steep::Parser
  def initialize: -> any
  def parse: (any, any, ?debug: any) -> any
  def reset_method_context!: -> any
  def parse_line: (any) -> any
  def try_parse_comment: (any) -> any
  def try_parse_param_or_return: (any) -> any
  def try_parse_end: (any) -> any
  def try_parse_postfix_if: (any) -> any
  def try_parse_begin_end: (any) -> any
  def try_parse_class: (any) -> any
  def try_parse_constant: (any) -> any
  def try_parse_singleton_class: (any) -> any
  def try_parse_param: (any) -> any
  def try_parse_return: (any) -> any
  def try_parse_method: (any) -> any
  def try_parse_method_with_no_action: (any) -> any
  def parse_method_params: (any) -> any
  def try_parse_attr: (any) -> any
  def push_state!: (any) -> any
  def pop_state!: -> any
  def stack_is_empty?: -> any
  def type_node: (any) -> any
  def debug_print!: (any, ?offset: any) -> any
  def normalize_type: (any) -> any
  def normalize_multi_type: (any) -> any
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
