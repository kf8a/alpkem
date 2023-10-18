# frozen_string_literal: true

module Parsers
  # parser for switchgrass soil samples and deep core samples
  class GlbrcSwitchgrassCnParser < CNSampleParser
    SWITCHGRASS =
      '(\d+),\d+,\d{2}?((DC)?SWF\d+H\d+)[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(data)
      raw_date, @plot_name, _, @percent_n, @percent_c = ParserMatcher.parse(SWITCHGRASS, data)
      @sample_date = Date.parse(raw_date) if raw_date

      process_data
    end
  end
end
