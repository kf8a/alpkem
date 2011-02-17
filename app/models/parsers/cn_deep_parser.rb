#For parsing CN Deep Core files into Carbon/Nitrogen measurements.
class CNDeepParser < CNSampleParser

#  CN_DEEP_CORE        = ',\d*,\d*(.{1,11})[abc|ABC]?,(\d*\.\d*),\w*,(\w*),\w*,\w*,\w*,(\d*\.\d*),(\d*\.\d*)'
  CN_DEEP_CORE = '(\d+),\d+,"\d*DC(.{1,11})[ABC]",.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(CN_DEEP_CORE)

    if line =~ re
      @sample_date = Date.parse($1)
      @plot_name   = $2
      @percent_n   = $3
      @percent_c   = $4

      process_data
    end
  end

end
