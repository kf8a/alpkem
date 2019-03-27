module Parsers
  class GLBRCSwitchgrassCNParser < CNSampleParser

    SWITCHGRASS = '(\d+),\d+,(SWF\d+H\d+)[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(data)
      raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(SWITCHGRASS, data)
      @sample_date = Date.parse(raw_date) if raw_date

      process_data
    end
  end
end
