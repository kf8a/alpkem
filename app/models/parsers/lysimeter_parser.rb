#For parsing Lysimeter samples
class LysimeterParser < FileParser

  LYSIMETER = '(\w{1,2})-(\d)-(\d)[ABC|abc], (\d{8})\s+-?\d+\t\s+(-?\d+\.\d+)\t\w*\t+\s+-?\d+\t\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(LYSIMETER)
    @first, @second, @third, raw_date, @nh4_amount, @no3_amount =
        re.match(line).try(:captures)
    @sample_date = Date.parse(raw_date) if raw_date

    process_data unless @first.blank? || @second.blank? || @third.blank?
  end

  def process_data
    plot_name = "T#{@first}R#{@second}F#{@third}"
    find_plot(plot_name) unless self.plot.try(:name) == plot_name
    process_nhno_sample(@nh4_amount, @no3_amount) if plot_exists?
  end

end