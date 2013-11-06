class NH4StandardLineParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+.+(-*\d\.\d+)'

  def self.parse(line)
    ParserMatcher.parse(STANDARD_SAMPLE, line)
  end
end
