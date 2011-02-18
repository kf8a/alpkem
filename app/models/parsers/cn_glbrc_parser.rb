#For parsing Carbon/Nitrogen samples from GLBRC.
class CNGLBRCParser < CNSampleParser

  #GLBRC_CN            = '(\d+),\d+,\d+([G|L|M]\d+[R|S]\d{2}0\d{2})[ABC|abc],(\d+\.\d+),\d+,.+,(\d+\.\d+),(\d+\.\d+)'
  GLBRC_CN = '(\d+),\d+,"?\d*(.{1,11})[ABC]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(GLBRC_CN)

    if line =~ re
      @sample_date  = Date.parse($1)
      @plot_name    = $2
      @percent_n    = $3
      @percent_c    = $4

      process_data
    end
  end

end
