class CNGLBRCParser < FileParser

  GLBRC_CN            = '(\d+),\d+,\d+([G|L|M]\d+[R|S]\d{2}0\d{2})[ABC|abc],(\d+\.\d+),\d+,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(GLBRC_CN)

    if line =~ re
      s_date    = Date.parse($1)
      plot_name = $2
      percent_n = $4
      percent_c = $5

      if cn_plot_name_ok?(plot_name)
        find_plot(plot_name)
        process_cn_sample(s_date, percent_n, percent_c)
      end
    end
  end

end
