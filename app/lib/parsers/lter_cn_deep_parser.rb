# frozen_string_literal: true

module Parsers
  class LterCnDeepParser < CNSampleParser
    CN_DEEP_CORE_SAMPLE =
      '(\d+),\d+,(T.+R\dS\dC\d)-(\d+)-[abc|ABC],\d+(?:\.\d+)?,\w+,\w+,,,,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      raw_date, @plot_name, depth, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE_SAMPLE, line)
      if raw_date
        @sample_date = Date.parse(raw_date)
        @plot_name = @plot_name + '-' + depth
        process_data if cn_plot_name_ok?
      end
    end
  end
end
