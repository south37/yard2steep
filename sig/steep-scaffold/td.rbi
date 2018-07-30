class Yard2steep::Comments
  @comments_map: any
  @p_types: any
  @r_type: any
  def initialize: (any) -> any
  def parse_from: (any) -> Array<any>
  def reset_context!: () -> any
  def extract: (any) -> any
  def parse_comment!: (any) -> any
  def try_param_comment: (any) -> bool
  def try_return_comment: (any) -> bool
  def normalize_type: (any) -> any
end

Yard2steep::Comments::S_RE: Regexp
Yard2steep::Comments::TYPE_WITH_PAREN_RE: Regexp
Yard2steep::Comments::COMMENT_RE: Regexp
Yard2steep::Comments::PARAM_RE: Regexp
Yard2steep::Comments::RETURN_RE: Regexp
module Yard2steep::AST
end

class Yard2steep::Parser
  @debug: any
  @file: any
  @comments: any
  @ast: any
  @current_class: any
  @p_types: any
  @r_type: any
  def initialize: () -> any
  def parse: (any, any, ?debug: bool) -> any
  def parse_program: (any) -> any
  def parse_stmts: (any) -> any
  def parse_stmt: (any) -> any
  def parse_defs: (any) -> any
  def parse_def: (any) -> any
  def parse_method_impl: (any, any, any) -> any
  def parse_params: (any) -> any
  def parse_paren_params: (any) -> any
  def parse_no_paren_params: (any) -> any
  def within_context: () -> any
  def parse_class_or_module: (any) -> any
  def parse_bodystmt: (any) -> any
  def parse_assign: (any) -> void
  def parse_assign_constant: (name: any, v_ast: any) -> any
  def type_of: (any) -> String
  def parse_command: (any) -> void
  def parse_command_args_add_block: (any) -> any
  def parse_method_add_arg: (any) -> void
  def parse_attr_reader: (any) -> any
  def parse_attr_writer: (any) -> any
  def parse_attr_accessor: (any) -> any
  def getter_method_node: (any) -> any
  def setter_method_node: (any) -> any
  def debug_print!: (any) -> void
  def type_node: (any) -> any
  def block_type_node: (any) -> any
end

Yard2steep::Parser::ANY_TYPE: String
Yard2steep::Parser::ANY_BLOCK_TYPE: String
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

class Yard2steep::Type::TypeBase
  def to_s: () -> any
end

class Yard2steep::Type::AnyType
  def to_s: () -> String
end

class Yard2steep::Type::NormalType
  @type: any
  def initialize: (type: any) -> any
  def to_s: () -> any
end

class Yard2steep::Type::ArrayType
  @type: any
  def initialize: (type: any) -> any
  def to_s: () -> String
end

class Yard2steep::Type::HashType
  @key: any
  @val: any
  def initialize: (key: any, val: any) -> any
  def to_s: () -> String
end

class Yard2steep::Type::UnionType
  @types: any
  def initialize: (types: any) -> any
  def to_s: () -> any
end

class Yard2steep::Type::Parser
  @tokens: any
  @types: any
  def initialize: (any) -> Array<any>
  def parse: () -> any
  def parse_type: () -> any
  def parse_normal_type: (any) -> any
  def parse_multiple_types: (any) -> any
  def parse_array: () -> any
  def parse_hash: () -> any
  def expect!: (any) -> any
  def get: () -> any
  def peek: () -> any
  def debug_print!: (any) -> any
  def self.parse: (any) -> any
end

class Yard2steep::Type
  @text: any
  def initialize: (any) -> any
  def translate: () -> any
  def tokens: (any) -> any
  def self.translate: (any) -> any
end

Yard2steep::Type::S_RE: Regexp
Yard2steep::Type::TOKENS: Regexp
module Yard2steep::Util
  def self.assert!: () -> any
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
  @super_c: any
  @c_list: any
  @m_list: any
  @ivar_list: any
  @ivarname_s: any
  @children: any
  @parent: any
  @long_name: any
  @long_super: any
  def initialize: (kind: any, c_name: any, super_c: any, parent: any) -> any
  def append_constant: (any) -> any
  def append_m: (any) -> any
  def append_ivar: (any) -> void
  def append_child: (any) -> any
  def long_name: () -> any
  def long_super: () -> any
  def to_s: () -> any
  def inspect: () -> String
  def self.create_main: () -> any
end

Yard2steep::AST::ClassNode::KIND: Array<any>
class Yard2steep::AST::ConstantNode
  @name: any
  @klass: any
  @v_type: any
  def initialize: (name: any, klass: any, v_type: any) -> any
  def long_name: () -> String
end

class Yard2steep::AST::IVarNode
  @name: any
  def initialize: (name: any) -> any
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
  def gen_ivar_list!: (any, off: any) -> any
  def gen_c_list!: (any, off: any) -> any
  def gen_children!: (any, off: any) -> any
  def gen_c!: (any, off: any) -> any
  def gen_m!: (any, off: any) -> any
  def gen_p_list!: (any) -> void
  def gen_block_p!: (any) -> any
  def gen_m_p!: (any) -> any
end

