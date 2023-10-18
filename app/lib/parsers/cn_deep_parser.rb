# frozen_string_literal: true

#For parsing CN Deep Core files into Carbon/Nitrogen measurements.
# DEPRECATED
module Parsers
  class CnDeepParser < CNSampleParser

    #  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'
    CN_DEEP_CORE = '(\d+),\d+,"?\d*DC(.{1,11})[ABC]"?,.+,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE, line)
      @sample_date = Date.parse(raw_date) if raw_date
      process_data if cn_plot_name_ok?
    end
  end
end
