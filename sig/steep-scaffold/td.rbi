module Yard2steep::AST
end

class Yard2steep::Parser
  @debug: any
  @file: any
  @ast: any
  @stack: any
  @state: any
  @current_class: any
  @p_types: any
  @r_type: any
  @m_name: any
  def initialize: () -> any
  def parse: (any, any, ?debug: bool) -> any
  def reset_method_context!: () -> any
  def parse_line: (any) -> any
  def try_parse_comment: (any) -> bool
  def try_parse_param_or_return: (any) -> void
  def try_parse_end: (any) -> bool
  def try_parse_postfix_if: (any) -> any
  def try_parse_begin_end: (any) -> bool
  def try_parse_class: (any) -> bool
  def try_parse_constant: (any) -> bool
  def try_parse_singleton_class: (any) -> bool
  def try_parse_param: (any) -> bool
  def try_parse_return: (any) -> bool
  def try_parse_method: (any) -> bool
  def try_parse_method_with_no_action: (any) -> bool
  def parse_method_params: (any) -> any
  def push_state!: (any) -> any
  def pop_state!: () -> void
  def stack_is_empty?: () -> any
  def type_node: (any) -> any
  def debug_print!: (any, ?offset: Integer) -> void
  def normalize_type: (any) -> any
  def normalize_multi_type: (any) -> any
end

Yard2steep::Parser::S_RE: Regexp
Yard2steep::Parser::S_P_RE: Regexp
Yard2steep::Parser::PRE_RE: Regexp
Yard2steep::Parser::POST_RE: Regexp
Yard2steep::Parser::CLASS_RE: Regexp
Yard2steep::Parser::MODULE_RE: Regexp
Yard2steep::Parser::S_CLASS_RE: Regexp
Yard2steep::Parser::END_RE: Regexp
Yard2steep::Parser::CONSTANT_ASSIGN_RE: Regexp
Yard2steep::Parser::POSTFIX_IF_RE: Regexp
Yard2steep::Parser::BEGIN_END_RE: Regexp
Yard2steep::Parser::COMMENT_RE: Regexp
Yard2steep::Parser::TYPE_WITH_PAREN_RE: Regexp
Yard2steep::Parser::PARAM_RE: Regexp
Yard2steep::Parser::RETURN_RE: Regexp
Yard2steep::Parser::PAREN_RE: Regexp
Yard2steep::Parser::ARGS_RE: Regexp
Yard2steep::Parser::METHOD_RE: Regexp
Yard2steep::Parser::STATES: Hash<any, any>
Yard2steep::Parser::ANY_TYPE: String
Yard2steep::Parser::ANY_BLOCK_TYPE: String
Yard2steep::Parser::ARRAY_TYPE_RE: Regexp
Yard2steep::Parser::FIXED_ARRAY_TYPE_RE: Regexp
Yard2steep::Parser::HASH_TYPE_RE: Regexp
class Yard2steep::CLI
  @option: any
  @src_dir: any
  @dst_dir: any
  def initialize: (any) -> any
  def run!: () -> any
  def src_dir: () -> any
  def dst_dir: () -> any
  def traverse_dir!: (any) -> any
  def translate!: (any) -> any
  def self.run!: (any) -> any
end

class Yard2steep::CLI::Option
  @src: any
  @dst: any
  @debug: bool
  @debug_ast: bool
  def initialize: () -> bool
  def parse!: (any) -> void
end

class Yard2steep::Engine
  def self.execute: (any, any, ?debug: bool, ?debug_ast: bool) -> any
end

module Yard2steep::Util
  def self.assert!: { () -> any } -> void
end

class Yard2steep::Util::AssertError
end

class Yard2steep::AST::MethodNode
  @p_list: any
  @r_type: any
  @m_name: any
  def initialize: (m_name: any, p_list: any, r_type: any) -> any
end

class Yard2steep::AST::ClassNode
  @kind: any
  @c_name: any
  @c_list: any
  @m_list: any
  @children: any
  @parent: any
  @long_name: any
  def initialize: (kind: any, c_name: any, parent: any) -> any
  def append_constant: (any) -> any
  def append_m: (any) -> any
  def append_child: (any) -> any
  def long_name: () -> any
  def to_s: () -> any
  def inspect: () -> String
  def self.create_main: () -> any
end

Yard2steep::AST::ClassNode::KIND: Array<any>
class Yard2steep::AST::ConstantNode
  @name: any
  @klass: any
  def initialize: (name: any, klass: any) -> any
  def long_name: () -> String
end

class Yard2steep::AST::PTypeNode
  @p_type: any
  @p_name: any
  @kind: any
  def initialize: (p_type: any, p_name: any, kind: any) -> any
end

Yard2steep::AST::PTypeNode::KIND: Hash<any, any>
class Yard2steep::AST::PNode
  @type_node: any
  @style: any
  def initialize: (type_node: any, style: any) -> any
end

Yard2steep::AST::PNode::STYLE: Hash<any, any>
module Yard2steep
end

Yard2steep::VERSION: String
class Yard2steep::Gen
  @out: any
  def initialize: () -> any
  def gen: (any) -> any
  def emit!: (any, ?off: Integer) -> any
  def gen_child!: (any, off: any) -> any
  def gen_m_list!: (any, off: any) -> any
  def gen_c_list!: (any, off: any) -> any
  def gen_children!: (any, off: any) -> any
  def gen_c!: (any, off: any) -> any
  def gen_m!: (any, off: any) -> any
  def gen_p_list!: (any) -> void
  def gen_block_p!: (any) -> any
  def gen_m_p!: (any) -> any
end

