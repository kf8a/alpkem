# frozen_string_literal: true

module Parsers
  #For parsing soil Carbon/Nitrogen samples from GLBRC.
  class CNGLBRCParser < CNSampleParser

    GLBRC_CN = '(\d+),\d+,"?\d*(.{1,11})[ABC]"?,.+,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(GLBRC_CN, line)
      @sample_date = Date.parse(raw_date) if raw_date
      process_data if cn_plot_name_ok?
    end
  end
end
