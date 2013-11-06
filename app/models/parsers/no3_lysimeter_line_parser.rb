#For parsing Lysimeter samples that only have NO3 measurements (no NH4).
class NO3LysimeterLineParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)[ABC|abc], (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def self.parse(line)
    first, second, third, raw_date, no3_amount = ParserMatcher.parse(LYSIMETER_SINGLE, line)
    sample_date = Date.parse(raw_date) if raw_date
    [first, second, third, sample_date, nil, no3_amount]
  end

end
