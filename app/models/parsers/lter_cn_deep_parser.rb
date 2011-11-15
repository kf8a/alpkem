class LterCnDeepParser < CNSampleParser

  REGEX = '(\d+),\d+,(T\d\dR\dS\dC\d[SMD])[ABC],.+,(\d+\.\d+),(\d+\.\d+)'
  
  def process_line(line)
    re = Regexp.new(REGEX)
    raw_date, @plot_name, @percent_n, @percent_c = re.match(line).try(:captures)
    @sample_date = Date.parse(raw_date) if raw_date
    process_data if cn_plot_name_ok?
  end
end
