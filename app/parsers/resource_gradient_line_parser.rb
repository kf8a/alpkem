class ResourceGradientLineParser
  GENERIC_SAMPLE     = '(\d{3})\s+(F\d)\s+\d+\s+(-*\d+\.\d+)\s+\d+\s*-*\d+\s*(-*\d+\.\d+)'

  def self.parse(line)
    ParserMatcher.parse(GENERIC_SAMPLE, line)
  end
end
