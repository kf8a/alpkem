class CNDeepParser < CNSampleParser

  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_DEEP_CORE)

    if line =~ re
      @s_date      = @sample_date
      @plot_name   = $1
      @percent_n   = $4
      @percent_c   = $5

      process_data
    end
  end

end
