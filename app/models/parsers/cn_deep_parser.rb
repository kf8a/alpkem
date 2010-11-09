class CNDeepParser < FileParser

  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_DEEP_CORE)

    if line =~ re
      s_date      = @sample_date
      plot_name   = $1
      percent_n   = $4
      percent_c   = $5

      if cn_plot_name_ok?(plot_name)
        find_plot(plot_name)
        process_cn_sample(s_date, percent_n, percent_c)
      end
    end
  end

end
