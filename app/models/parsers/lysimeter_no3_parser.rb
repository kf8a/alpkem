#For parsing Lysimeter samples that only have NO3 measurements (no NH4).
class LysimeterNO3Parser < LysimeterParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER_SINGLE)

    if line =~ re
      @sample_date = $5
      @nh4_amount = nil
      @no3_amount = $6

      @first = $1
      @second = $2
      @third = $3

      process_data
    end
  end

end
