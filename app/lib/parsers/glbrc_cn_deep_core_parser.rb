# frozen_string_literal: true

# For parsing GLBRC deep core Carbon and Nitrogen samples.
module Parsers
  class GLBRCCNDeepCoreParser < CNSampleParser

    CN_DEEP_CORE_SAMPLE =
      '(\d+),\d+,(\d+)?(\w+..R\dS.+C?\d?)-(\d+)-[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      date, _dup_date, @plot_name, @depth, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE_SAMPLE, line)
      return unless date

      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      @plot_name = @plot_name.gsub(/0(\d)/, '\1')
      @plot_name = @plot_name + '-' + @depth

      Plot.find_or_create_by(name: @plot_name, study_id: 11)

      process_data
    end
  end
end
