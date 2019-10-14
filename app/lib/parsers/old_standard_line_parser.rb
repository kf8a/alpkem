# frozen_string_literal: true

module Parsers
  class OldStandardLineParser
    STANDARD_SAMPLE =
      '([L|M]?\w{1,2})[-|S](\d{1,2})[abc|ABC]\s+-?\d+\.\d+\s+(-?\d+\.\d+).+-?\d+\.\d+\s+(-?\d+\.\d+).+'

    def self.parse(line)
      ParserMatcher.parse(STANDARD_SAMPLE, line)
    end
  end
end
