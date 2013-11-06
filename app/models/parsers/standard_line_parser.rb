class StandardLineParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+\s+(-*\d+\.\d+)\t.*\t *-*\d+\t\s*(-*\d+\.\d+)'

  def self.parse(line)
    re = Regexp.new(STANDARD_SAMPLE)
    matches = re.match(line)
    matches.captures if matches
  end
end
