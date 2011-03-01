#For parsing Lysimeter samples that only have NO3 measurements (no NH4).
class LysimeterNO3Parser < LysimeterParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)[ABC|abc], (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER_SINGLE)
    @first, @second, @third, raw_date, @no3_amount = re.match(line).try(:captures)
    @sample_date = Date.parse(raw_date) if raw_date
    @nh4_amount = nil

    process_data unless @first.blank? || @second.blank? || @third.blank?
  end

end
