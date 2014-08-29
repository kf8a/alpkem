module Parsers
  #Generic parser to convert files to measurements.
  class LterSoilParser < FileParser

    def parse_data(data)
      line_parser_name = FileFormatSelector.new.get_line_parser_prefix(data) + 'GenericLineParser'

      data.each { | line | process_line(line, line_parser_name.constantize) }
      if self.measurements.blank?
        self.load_errors += "No data was able to be loaded from this file."
      end
    end

    def process_line(line, line_parser)
      date, plot_name, modifier, nh4_amount, no3_amount = line_parser.parse(line)

      if plot_name && modifier
        # plot_name = plot_name + '-' + modifier
        find_plot(plot_name)
        process_nhno_sample(nh4_amount, no3_amount) if plot.present?
      end
    end

  end
end
