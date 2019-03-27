class ParserMatcher
  def self.parse(pattern, line)
    re = Regexp.new(pattern)
    matches = re.match(line)
    matches.captures if matches
  end
end
