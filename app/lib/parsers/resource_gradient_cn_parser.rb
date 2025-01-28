# frozen_string_literal: true

module Parsers
  # For parsing GLBRC surface soil Carbon and Nitrogen samples.
  class ResourceGradientCnParser< CNSampleParser
    CN_SOIL_SAMPLE =
      '(\d+).(\d+).(\d+),\d+,(\d+-F\d)[A|B|C],.+,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      month, day, year, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_SOIL_SAMPLE, line)
      return unless month

      p [month, day, year, @plot_name, @percent_n, @percent_c]
      @sample_date = Date.new(year.to_i, month.to_i,day.to_i)

      @plot_name = @plot_name + '-' + '025'
      _plot, treatment, _depth = @plot_name.split('-')

      Plot.find_or_create_by(name: @plot_name, study_id: 10, top_depth: 0, bottom_depth: 25, treatment_name: treatment )

      process_data
    end

  end
end
