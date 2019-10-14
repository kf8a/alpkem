# frozen_string_literal: true

module Parsers
  class StandardLineParser
    STANDARD_SAMPLE =
      '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+\s+(-*\d+\.\d+)\t.*\t *-*\d+\t\s*(-*\d+\.\d+)'

    def self.parse(line)
      ParserMatcher.parse(STANDARD_SAMPLE, line)
    end
  end
end
