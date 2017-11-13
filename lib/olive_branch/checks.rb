class Checks
  def self.content_type_check(content_type)
    content_type =~ /application\/json/
  end
end
