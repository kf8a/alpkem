#For parsing generic Carbon and Nitrogen samples.
class CNSampleParser < FileParser

  CN_SAMPLE           = ',\d*,(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?\w*"?,".*",\d*\.\d*,.*,"?\w*"?,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_SAMPLE)
    @sample_date, @plot_name, @percent_n, @percent_c = re.match(line).try(:captures)
    process_data if cn_plot_name_ok?
  end

  def process_data
    find_plot(@plot_name) unless self.plot.try(:name) == @plot_name
    process_cn_sample if plot_exists?
  end

end
