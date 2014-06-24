class Parsers::CNGenericParser < Parsers::CNSampleParser
  CN_DEEP_CORE = '(\d+),\d+,"?\d*(.*)[ABC|abc]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE, line)
    @sample_date = Date.parse(raw_date) if raw_date
    if @plot_name
      unless @plot_name =~ /-/
        @plot_name, @modifier = ParserMatcher.parse('(.*\d)(.*)', @plot_name)
        @plot_name = @plot_name + '-' + @modifier
      end
    end
    process_data if cn_plot_name_ok?
  end
end
