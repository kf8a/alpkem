#For parsing Carbon/Nitrogen samples from GLBRC.
class CNGLBRCParser < CNSampleParser

  #GLBRC_CN            = '(\d+),\d+,\d+([G|L|M]\d+[R|S]\d{2}0\d{2})[ABC|abc],(\d+\.\d+),\d+,.+,(\d+\.\d+),(\d+\.\d+)'
  GLBRC_CN = '(\d+),\d+,"?\d*(.{1,11})[ABC]"?,.+,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(GLBRC_CN)
    raw_date, @plot_name, @percent_n, @percent_c = re.match(line).try(:captures)
    @sample_date = Date.parse(raw_date) if raw_date
    process_data if cn_plot_name_ok?
  end

end
