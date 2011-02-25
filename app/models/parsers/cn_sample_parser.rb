#For parsing generic Carbon and Nitrogen samples.
class CNSampleParser < FileParser

  CN_SAMPLE           = ',(\d*),(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?(\w*)"?,"(.*)",(\d*\.\d*),.*,"?(\w*)"?,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_SAMPLE)

    if line =~ re
      @sample_date = $2
      @plot_name   = $3
      @percent_n   = $8
      @percent_c   = $9

      process_data if cn_plot_name_ok?
    end
  end

  def process_data
    find_plot(@plot_name) unless self.plot.try(:name) == @plot_name
    process_cn_sample if plot_exists?
  end

end
