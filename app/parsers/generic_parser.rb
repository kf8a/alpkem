#Generic parser to convert files to measurements.
class Parsers::GenericParser < Parsers::FileParser

  def parse_data(data)
    line_parser_name = FileFormatSelector.new.get_line_parser_prefix(data) + 'GenericLineParser'

    data.each { | line | process_line(line, line_parser_name.constantize) }
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def process_line(line, line_parser)
    date, plot, modifier, nh4_amount, no3_ammount = line_parser.parse(line)
 
    unless plot.try(:name) == plot_name
      find_plot(plot_name) 
    end
    process_nhno_sample(nh4_amount, no3_amount) if plot.present?
  end

end
