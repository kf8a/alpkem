#For getting soil samples out of old-style files.
class OldSoilParser < FileParser

  OLD_SOIL_SAMPLE     = '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*(\d+)\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

  def process_line(line)
    re = Regexp.new(OLD_SOIL_SAMPLE)

    if line =~ re
      nh4_amount = $5
      no3_amount = $6

      first = $1
      second = $2

      unless first.blank? || second.blank?
        plot_name = "G#{first}R#{second}"
        find_plot(plot_name) unless self.plot.try(:name) == plot_name
        process_nhno_sample(nh4_amount, no3_amount)
      end
    end
  end

end
