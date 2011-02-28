#For parsing Lysimeter samples that only have NO3 measurements (no NH4).
class LysimeterNO3Parser < LysimeterParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER_SINGLE)

    if line =~ re
      @first, @second, @third   = $1, $2, $3
      @sample_date              = Date.parse($5)
      @nh4_amount, @no3_amount  = nil, $6

      process_data unless @first.blank? || @second.blank? || @third.blank?
    end
  end

end
