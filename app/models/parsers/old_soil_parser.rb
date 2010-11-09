class OldSoilParser < FileParser

  OLD_SOIL_SAMPLE     = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*(\d+)\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

  def process_line(line)
    re = Regexp.new(OLD_SOIL_SAMPLE)

    if line =~ re
      s_date = @sample_date

      nh4_amount = $5
      no3_amount = $6

      first = $1
      second = $2

      unless first.blank? || second.blank?
        plot_name = "G#{first}R#{second}"
        find_plot(plot_name)
        process_nhno_sample(s_date, nh4_amount, no3_amount)
      end
    end
  end

end
