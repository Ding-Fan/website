module Homeland
  class Pipeline
    class NormalizeMentionFilter < HTML::Pipeline::TextFilter
      PREFIX_REGEXP = %r{(^|[^A-Za-z0-9\-\_\.!#/\$%&*@＠])}
      USER_REGEXP   = /#{PREFIX_REGEXP}@([A-Za-z0-9\-\_\.]{1,20})/io

      def call
        users = []
        # Makesure clone a new value, not change original value
        text = @text.clone
        text.gsub!(USER_REGEXP) do
          prefix = Regexp.last_match(1)
          user   = Regexp.last_match(2)
          users.push(user)
          "#{prefix}@user#{users.size}"
        end
        result[:normalize_mentions] = users
        text
      end
    end
  end
end
