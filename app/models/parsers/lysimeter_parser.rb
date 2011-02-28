#For parsing Lysimeter samples
class LysimeterParser < FileParser

  LYSIMETER = '(\w{1,2})-(\d)-(\d)([ABC|abc]), (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)\t(\w+)?\t+\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER)
    if line =~ re
      @first, @second, @third   = $1, $2, $3
      @sample_date              = Date.parse($5)
      @nh4_amount, @no3_amount  = $6, $8

      process_data unless @first.blank? || @second.blank? || @third.blank?
    end
  end

  def process_data
    plot_name = "T#{@first}R#{@second}F#{@third}"
    find_plot(plot_name) unless self.plot.try(:name) == plot_name
    process_nhno_sample(@nh4_amount, @no3_amount) if plot_exists?
  end

end