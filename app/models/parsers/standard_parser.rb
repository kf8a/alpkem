#Generic parser to convert files to measurements.
class StandardParser < FileParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC]( rerun)*\t\s+-*(\d+).+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)'

  def process_line(line)
    re = Regexp.new(STANDARD_SAMPLE)

    if line =~ re
      first, second, nh4_amount, no3_amount = $1, $2, $5, $6

      unless first.blank? || second.blank?
        if @sample_type_id == 2
          plot_name = "T#{first}R#{second}"
        elsif first.start_with?("L0") || first.start_with?("M0")
          plot_name = "#{first}S#{second}"
        else
          plot_name = "G#{first}R#{second}"
        end
        find_plot(plot_name) unless self.plot.try(:name) == plot_name
        process_nhno_sample(nh4_amount, no3_amount) if plot_exists?
      end
    end
  end

  def get_plot_name(first, second)
    if @sample_type_id == 2
      "T#{first}R#{second}"
    elsif first.start_with?("L0")
      "#{first}S#{second}"
    else
      "G#{first}R#{second}"
    end
  end

end
