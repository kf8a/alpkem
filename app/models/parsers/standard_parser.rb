#Generic parser to convert files to measurements.
class StandardParser < FileParser

  STANDARD_SAMPLE = '\t\d{3}\t(L?\w{1,2})-?S?(\d{1,2})[abc|ABC]( rerun)*\t\s+-*(\d+).+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)'

  def process_line(line)
    re = Regexp.new(STANDARD_SAMPLE)

    if line =~ re
      nh4_amount = $5
      no3_amount = $6

      first = $1
      second = $2

      unless first.blank? || second.blank?
        plot_name = get_plot_name(first, second)
        find_plot(plot_name)
        process_nhno_sample(nh4_amount, no3_amount)
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