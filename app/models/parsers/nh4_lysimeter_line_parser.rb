#For parsing Lysimeter samples that only have NO3 measurements (no NH4).
class NH4LysimeterLineParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)[ABC|abc], (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def self.parse(line)
    re = Regexp.new(LYSIMETER_SINGLE)
    first, second, third, raw_date, nh4_amount = re.match(line).try(:captures)
    sample_date = Date.parse(raw_date) if raw_date
    [first, second, third, sample_date, nh4_amount]
  end

end
