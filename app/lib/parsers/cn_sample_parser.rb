# frozen_string_literal: true

module Parsers
  # For parsing generic Carbon and Nitrogen samples.
  class CNSampleParser < FileParser
    CN_SAMPLE =
      ',\d*,(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?\w*"?,".*",\d*\.\d*,.*,"?\w*"?,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      @sample_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_SAMPLE, line)
      process_data if cn_plot_name_ok?
    end

    def process_data
      find_plot(@plot_name) unless plot.try(:name) == @plot_name
      process_cn_sample if plot.present?
    end
  end
end
