#Generic parser to convert files to measurements.
class Parsers::StandardParser < Parsers::FileParser

  STANDARD_SAMPLE     = '\t([M|L]?\w{1,2})-?S?(\d{1,2})[abc|ABC](?: rerun)*\t\s+-*\d+.+(-*\d\.\d+)\t.*\t *-*\d+\t\s*(-*\d\.\d+)'

  def process_line(line)
    re = Regexp.new(STANDARD_SAMPLE)
    first, second, nh4_amount, no3_amount = re.match(line).try(:captures)
    unless first.blank? || second.blank?
      plot_name = get_plot_name(first, second)
      find_plot(plot_name) unless self.plot.try(:name) == plot_name
      process_nhno_sample(nh4_amount, no3_amount) if plot.present?
    end
  end

  def get_plot_name(first, second)
    if @sample_type_id == 2
      "T#{first}R#{second}"
    elsif first.start_with?("L0") || first.start_with?("M0")
      "#{first}S#{second}"
    else
      "G#{first}R#{second}"
    end
  end

end
