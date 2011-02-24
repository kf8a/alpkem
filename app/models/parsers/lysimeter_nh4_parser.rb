#For parsing Lysimeter samples that only have NH4 measurements (no NO3).
class LysimeterNH4Parser < LysimeterParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER_SINGLE)

    if line =~ re
      @sample_date = Date.parse($5)

      @nh4_amount = $6
      @no3_amount = nil

      @first = $1
      @second = $2
      @third = $3

      process_data unless @first.blank? || @second.blank? || @third.blank?
    end
  end

end
