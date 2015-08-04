module Parsers
  class LterCnDeepParser < CNSampleParser

    # REGEX = '(\d+),\d+,(T..(?:nt)?R\dS\dC\d[SMD])[ABC],.+,(\d+\.\d+),(\d+\.\d+)'
    CN_DEEP_CORE_SAMPLE        = '(\d+),\d+,(T.+R\dS\dC\d)-(\d+)-[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      raw_date, @plot_name, depth, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE_SAMPLE, line)
      @sample_date = Date.parse(raw_date)
      @plot_name = @plot_name + case depth.to_i
      when 122 then "D"
      when 55  then "M"
      when 25  then "T"
      when 10  then "S"
      end
      process_data if cn_plot_name_ok?
    end
  end
end
