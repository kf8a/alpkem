class StandardParser < FileParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC]( rerun)*\t\s+-*(\d+).+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)'

  def process_line(line)
    re = Regexp.new(STANDARD_SAMPLE)

    if line =~ re
      s_date = @sample_date

      nh4_amount = $5
      no3_amount = $6

      first = $1
      second = $2

      unless first.blank? || second.blank?
        if @sample_type_id == 2
          plot_name = "T#{first}R#{second}"
        elsif first.start_with?("L0")
          plot_name = "#{first}S#{second}"
        elsif first.starts_With("M0")
          plot_name = "#{first}S#{second}"
        else
          plot_name = "G#{first}R#{second}"
        end
        find_plot(plot_name)
        process_nhno_sample(s_date, nh4_amount, no3_amount)
      end
    end
  end

end