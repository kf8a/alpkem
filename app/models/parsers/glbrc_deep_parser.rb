#For parsing Deep Core samples from GLBRC.
class GLBRCDeepParser < FileParser

  GLBRC_DEEP_CORE = '\t\d{3}\t(G\d+R\dS\d\d{2})\w*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'

  def process_line(line)
    plot_name, nh4_amount, no3_amount = Regexp.new(GLBRC_DEEP_CORE).match(line).try(:captures)
    if plot_name && nh4_amount && no3_amount
      find_plot(plot_name) unless self.plot.try(:name) == plot_name
      process_nhno_sample(nh4_amount, no3_amount) if plot_exists?
    end
  end

end
