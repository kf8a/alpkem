class Parsers::SWFParser < Parsers::CNSampleParser

  SWF_CN = '(\d+),\d+,"?(SWF)(\d)(\d{3})H(\d)[ABC]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(SWF_CN)
    raw_date, @prefix, @rate, @plot_name, @harvest, @percent_n, @percent_c = re.match(line).try(:captures)
    @plot_name = @prefix + @plot_name
    @sample_date = Date.parse(raw_date) if raw_date
    process_data if cn_plot_name_ok?
  end

end
