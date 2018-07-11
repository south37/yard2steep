class Yard2steep::Comments
  def initialize: (String) -> any
  def parse_from: (Integer) -> Array<Hash<String, String> | String>
  def reset_context!: -> void
  def extract: (String) -> Hash<String, String>
  def parse_comment!: (String) -> void
  def try_param_comment: (String) -> bool
  def try_return_comment: (String) -> bool
  def normalize_type: (String) -> String
end
Yard2steep::Comments::S_RE: Regexp
Yard2steep::Comments::TYPE_WITH_PAREN_RE: Regexp
Yard2steep::Comments::COMMENT_RE: Regexp
Yard2steep::Comments::PARAM_RE: Regexp
Yard2steep::Comments::RETURN_RE: Regexp
