class GenericLineParser

  GENERIC_SAMPLE     = '\t(\d+)(\w+)-(\d+?)-[abc|ABC](?: rerun)*\t\s+-*\d+\s+(-*\d+\.\d+)\t.*\t *-*\d+\t\s*(-*\d+\.\d+)'

  def self.parse(line)
    ParserMatcher.parse(GENERIC_SAMPLE, line)
  end
end
