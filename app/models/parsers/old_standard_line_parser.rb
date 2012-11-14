class OldStandardLineParser

  STANDARD_SAMPLE   = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]\t\s+-?\d+\.\d+\s+(-?\d+\.\d+).+-?\d+\.\d+\s+(-?\d+\.\d+).+'

  def self.parse(line)
    re = Regexp.new(STANDARD_SAMPLE)
    if re.match(line)
      first, second, nh4_amount, no3_amount = re.match(line).captures
      [first, second, nh4_amount, no3_amount]
    end
  end

end
