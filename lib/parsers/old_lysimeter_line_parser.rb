module Parsers
  class OldLysimeterLineParser

    LYSIMETER = '(\w{1,2})-(\d)-(\d)[ABC|abc], (\d{8}).+\d+\.\d+\s+(-?\d+\.\d+).+\d+\.\d+\s+(-?\d+\.\d+)'

    def self.parse(line)
      first, second, third, raw_date, nh4_amount, no3_amount = ParserMatcher.parse(LYSIMETER, line)
      sample_date = Date.parse(raw_date) if raw_date
      [first, second, third, sample_date, nh4_amount, no3_amount]
    end
  end
end
