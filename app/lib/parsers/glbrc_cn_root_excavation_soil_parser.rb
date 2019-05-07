# frozen_string_literal: true

module Parsers
  # For parsing Root GLBC pit Carbon and Nitrogen samples.
  # TODO: This is actually root material not soil
  class GLBRCCNRootExcavationSoilParser < CNSampleParser
    CN_PIT_SAMPLE =
      '(\d+),\d+,(\w+)-(\d+)-[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      date, @plot_name, @depth, @percent_n, @percent_c = ParserMatcher.parse(CN_PIT_SAMPLE, line)
      p [date, @plot_name, @depth, @percent_n, @percent_c]
      return unless date

      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      @plot_name = @plot_name.gsub(/0(\d)/, '\1')
      @plot_name = @plot_name + '-' + @depth

      Plot.find_or_create_by(name: @plot_name, study_id: 14)

      process_data
    end
  end
end
