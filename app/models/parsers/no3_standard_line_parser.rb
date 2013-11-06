class NO3StandardLineParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+.+(-*\d\.\d+)'

  def self.parse(line)
    re = Regexp.new(STANDARD_SAMPLE)
    matches = re.match(line)
    if matches
      first, second, no3_amount = matches.captures
      [first, second, nil , no3_amount]
    end
  end
end
