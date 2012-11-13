class NH4LineParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+.+(-*\d\.\d+)'

  def self.parse(line)
    re = Regexp.new(STANDARD_SAMPLE)
    first, second, nh4_amount = re.match(line).try(:captures)
    [first, second,  nh4_amount]
  end
end
