class Parsers::CNGLBRCGenericParser < Parsers::CNSampleParser
  CN_DEEP_CORE = '(\d+),\d+,"?\d*(.*)[ABC|abc]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    raw_date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE, line)
    @sample_date = Date.parse(raw_date) if raw_date

    if @plot_name
      @plot_name = @plot_name.gsub(/0(\d)/,'\1')
      unless @plot_name =~ /-/
        @plot_name, @modifier = ParserMatcher.parse('(.*\d)(.*)', @plot_name)
        @plot_name = @plot_name + '-' + @modifier
      end
      Plot.find_or_create_by_name(:name=>@plot_name, :study_id => 8)
    end
    process_data #if cn_plot_name_ok?
  end
end
