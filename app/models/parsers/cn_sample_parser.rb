class CNSampleParser < FileParser

  CN_SAMPLE           = ',(\d*),(\d\d\/\d\d\/\d\d\d\d)?,"\d*(.{1,11})[ABC]?","?(\w*)"?,"(.*)",(\d*\.\d*),.*,"?(\w*)"?,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_SAMPLE)

    if line =~ re
      @s_date      = $2
      @plot_name   = $3
      @percent_n   = $8
      @percent_c   = $9

      process_data
    end
  end

  def process_data
    if cn_plot_name_ok?(@plot_name)
      find_plot(@plot_name)
      process_cn_sample(@s_date, @percent_n, @percent_c)
    end
  end

end
