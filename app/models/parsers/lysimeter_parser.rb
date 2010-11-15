#For parsing Lysimeter samples
class LysimeterParser < FileParser

  LYSIMETER = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)\t(\w+)?\t+\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER)

    if line =~ re
      @s_date = $5
      @nh4_amount  = $6
      @no3_amount  = $8

      @first = $1
      @second = $2
      @third = $3

      process_data
    end
  end

  def process_data
    unless @first.blank? || @second.blank? || @third.blank?
      plot_name = "T#{@first}R#{@second}F#{@third}"
      find_plot(plot_name)
      process_nhno_sample(@s_date, @nh4_amount, @no3_amount)
    end
  end

end