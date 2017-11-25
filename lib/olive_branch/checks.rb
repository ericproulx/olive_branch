# frozen_string_literal: true

class Checks
  def self.content_type_check(content_type)
    content_type =~ %r{application\/json}
  end
end
