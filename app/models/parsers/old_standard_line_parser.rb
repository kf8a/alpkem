class OldStandardLineParser

  STANDARD_SAMPLE   = '([L|M]?\w{1,2})[-|S](\d{1,2})[abc|ABC]\s+-?\d+\.\d+\s+(-?\d+\.\d+).+-?\d+\.\d+\s+(-?\d+\.\d+).+'

  def self.parse(line)
    re = Regexp.new(STANDARD_SAMPLE)
    if re.match(line)
      first, second, nh4_amount, no3_amount = re.match(line).captures
      [first, second, nh4_amount, no3_amount]
    end
  end

end
