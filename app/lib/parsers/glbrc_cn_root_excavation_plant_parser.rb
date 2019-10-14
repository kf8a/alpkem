# frozen_string_literal: true

module Parsers
  # For parsing GLBRC Root Excavatrion plant Carbon and Nitrogen samples.
  class GLBRCCNRootExcavationPlantParser < CNSampleParser
    CN_PLANT_SAMPLE =
      '(\d+),.+,(\d+)?([G|L|M]..R?\d?-?\S+)-[abc|ABC],.+,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    # https://rubular.com/r/g2cytUECX1jQjT
    def process_line(line)
      date, _x, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_PLANT_SAMPLE, line)
      return unless date

      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      @plot_name = @plot_name.gsub(/0(\d)/, '\1')

      Plot.find_or_create_by(name: @plot_name, study_id: 14)

      process_data
    end
  end
end
