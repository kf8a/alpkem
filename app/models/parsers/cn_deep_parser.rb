#For parsing CN Deep Core files into Carbon/Nitrogen measurements.
class CNDeepParser < CNSampleParser

  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'

  def process_line(line)
    re = Regexp.new(CN_DEEP_CORE)

    if line =~ re
      @plot_name   = $1
      @percent_n   = $4
      @percent_c   = $5

      process_data
    end
  end

end
