# frozen_string_literal: true

module Parsers
  # For parsing GLBRC surface soil Carbon and Nitrogen samples.
  class ResourceGradientCnParser< CNSampleParser
    CN_SOIL_SAMPLE =
      '(\d+).(\d+).(\d+),\d+,(\d+-F\d)[A|B|C],.+,(\d+\.\d+),(\d+\.\d+)$'

    def process_line(line)
      month, day, year, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_SOIL_SAMPLE, line)
      date = Date.new(year, month,day)
      return unless date

      @sample_date = date

      @plot_name = @plot_name + '-' + '0-25'

      Plot.find_or_create_by(name: @plot_name, study_id: 10)

      process_data
    end

  end
end
