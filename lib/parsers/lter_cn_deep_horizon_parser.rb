#DEPRECATED 2015-9-9
module Parsers
  class LterCnDeepHorizonParser < CNSampleParser

    REGEX = '(\d+),\d+,(T..(?:nt)?R\dS\dC\d[SMD])[ABC],.+,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(REGEX, line)
      @sample_date = Date.parse(raw_date) if raw_date
      process_data if cn_plot_name_ok?
    end
  end
end
