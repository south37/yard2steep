require 'yard2steep/type'

module Yard2steep
  class Comments
    S_RE = /[\s\t]*/
    TYPE_WITH_PAREN_RE = /
      \[
      (
        [^\]]
        *
      )
      \]
    /x
    COMMENT_RE = /^
      \#
      #{S_RE}
      @(?:param|return)
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
    /x
    PARAM_RE  = /
      \#
      #{S_RE}
      @param
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
      #{S_RE}
      (\w+)
    /x
    RETURN_RE = /
      \#
      #{S_RE}
      @return
      #{S_RE}
      #{TYPE_WITH_PAREN_RE}
    /x

    # @param [String] text
    def initialize(text)
      @comments_map = extract(text)
    end

    # @param [Integer] m_loc represents location of method definition
    # @return [Array(Hash { String => String }, String)]
    def parse_from(m_loc)
      Util.assert! { m_loc >= 0 }
      reset_context!

      l = m_loc - 1
      while l >= 0
        comment = @comments_map[l]
        break unless comment  # nil when no more comment exist

        parse_comment!(comment)
        l -= 1
      end

      [@p_types, @r_type]
    end

  private

    # @return [void]
    def reset_context!
      @p_types = {}
      @r_type  = nil
    end

    # @param [String] text
    # @return [Hash{ String => String }]
    def extract(text)
      # NOTE: `Ripper.lex` returns array of array such as
      # [
      #   [[1, 0], :on_comment, "# @param [Array] contents\n", EXPR_BEG],
      #   ...
      # ]
      r = {}
      Ripper.lex(text).each do |t|
        # Check token type
        type = t[1]
        next if type != :on_comment
        # Check comment body
        comment = t[2]
        next unless comment.match?(COMMENT_RE)

        line = t[0][0]
        r[line] = comment
      end

      r
    end

    # @param [String] comment
    # @return [void]
    def parse_comment!(comment)
      return if try_param_comment(comment)
      return if try_return_comment(comment)
      raise "Must not reach here!"
    end

    # @param [String] comment
    # @return [bool]
    def try_param_comment(comment)
      m = comment.match(PARAM_RE)
      return false unless m

      type = normalize_type(m[1])
      name = m[2]
      @p_types[name] = type

      true
    end

    # @param [String] comment
    # @return [bool]
    def try_return_comment(comment)
      m = comment.match(RETURN_RE)
      return false unless m

      @r_type = normalize_type(m[1])

      true
    end

    # @param [String] type
    # @return [String]
    def normalize_type(type)
      Type.translate(type)
    end
  end
end
