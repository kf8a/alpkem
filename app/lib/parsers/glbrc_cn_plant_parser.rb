# frozen_string_literal: true

module Parsers
  # For parsing GLBRC plant Carbon and Nitrogen samples.
  class GlbrcCnPlantParser < CNSampleParser
    CN_PLANT_SAMPLE =
      '(\d+),.+,(\d+)?([G|L|M]..R?\d?-?\S+)[abc|ABC],.+,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      date, _x, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_PLANT_SAMPLE, line)
      return unless date

      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      @plot_name = @plot_name.gsub(/0(\d)/, '\1')

      Plot.find_or_create_by(name: @plot_name, study_id: 8)

      process_data
    end
  end
end
