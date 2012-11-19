class Parsers::GLBRCScaleupBaseParser < Parsers::FileParser

  STANDARD_SAMPLE     = '([M|L]0\dS\d{5})[abc|ABC]\s+-?\d+\.\d+\s+(-?\d+\.\d+)\s+-?\d+\.\d+\s+(-?\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(STANDARD_SAMPLE)
    plot_name, nh4_amount, no3_amount = re.match(line).try(:captures)

    find_plot(plot_name) 
    unless plot
      Plot.create! :name => plot_name
      find_plot(plot_name)
    end
    process_nhno_sample(nh4_amount, no3_amount) if plot.present?
  end
end
