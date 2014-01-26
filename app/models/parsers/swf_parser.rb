class Parsers::SWFParser < Parsers::CNSampleParser

  SWF_CN = '(\d+),\d+,"?(SWF)(\d)(\d{3})(H\d)[ABC]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    raw_date, @prefix, @rate, @plot_name, @harvest, @percent_n, @percent_c = ParserMatcher.parse(SWF_CN, line)

    if cn_plot_name_ok?
      @plot_name = @prefix + @plot_name + @harvest
      @sample_date = Date.parse(raw_date) if raw_date
      process_data 
    end
  end

end
