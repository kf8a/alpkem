class LysimeterNH4Parser < LysimeterParser

  LYSIMETER_SINGLE = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER_SINGLE)

    if line =~ re
      @s_date = Date.parse($5)
      @nh4_amount = $6
      @no3_amount = nil

      @first = $1
      @second = $2
      @third = $3

      process_data
    end
  end

end
