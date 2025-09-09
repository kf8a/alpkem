# frozen_string_literal: true

module Parsers
  # For parsing Lysimeter samples
  class LysimeterParser < FileParser
    def parse_data(data)
      line_parser_name = "#{FileFormatSelector.new.get_line_parser_prefix(data)}LysimeterLineParser"

      data.each { |line| process_line(line, line_parser_name.constantize) }
      return unless measurements.blank?

      self.load_errors += "No data was able to be loaded from this file."
    end

    def process_line(line, line_parser)
      first, second, third, raw_date, nh4_amount, no3_amount = line_parser.parse(line)
      self.sample_date = raw_date
      return if first.blank? || second.blank? || third.blank?

      locate_plot(first, second, third)

      process_data(nh4_amount, no3_amount)
    end

    def locate_plot(first, second, third)
      plot_name = "T#{first}R#{second}F#{third}"
      find_plot(plot_name) unless plot.try(:name) == plot_name
    end

    def process_data(nh4_amount, no3_amount)
      process_nhno_sample(nh4_amount, no3_amount) if plot.present?
    end
  end
end
