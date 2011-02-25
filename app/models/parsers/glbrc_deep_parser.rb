#For parsing Deep Core samples from GLBRC.
class GLBRCDeepParser < FileParser

  GLBRC_DEEP_CORE     = '\t\d{3}\tG(\d+)R(\d)S(\d)(\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

  def process_line(line)
    re = Regexp.new(GLBRC_DEEP_CORE)

    if line =~ re
      nh4_amount = $5
      no3_amount = $6

      first = $1
      second = $2
      third = $3
      fourth = $4

      unless first.blank? || second.blank? || third.blank? || fourth.blank?
        plot_name = "G#{first}R#{second}S#{third}#{fourth}"
        find_plot(plot_name) unless self.plot.try(:name) == plot_name
        process_nhno_sample(nh4_amount, no3_amount) if plot_exists?
      end
    end
  end

end
