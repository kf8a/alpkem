# frozen_string_literal: true

module Parsers
  # For parsing GLBRC surface soil Carbon and Nitrogen samples.
  class GLBRCCNPitRootParser < CNSampleParser
    CN_ROOT_SAMPLE =
      '(\d+),\d+,(G.?.R\du?h)-(\w+)-[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      date, @plot_name, @modifier, @percent_n, @percent_c =
        ParserMatcher.parse(CN_ROOT_SAMPLE, line)
      return unless date

      @sample_date = parse_date(date)

      @plot_name = @plot_name.gsub(/0(\d)/, '\1')
      @plot_name = @plot_name + '-' + @modifier

      Plot.find_or_create_by(name: @plot_name, study_id: 11)

      process_data
    end

    def parse_date(date)
      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      Date.new(year, month, day)
    end
  end
end
