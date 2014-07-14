#For parsing GLBRC deep core Carbon and Nitrogen samples.
class Parsers::GLBRCCNDeepCoreParser < Parsers::CNSampleParser

 # CN_PLANT_SAMPLE           = '(\d{1,2}\/\d{1,2}\/\d\d\d\d),\d+,"?(G\d\dR\dm?\w+)[abc]"?,\d+\.\d+,"?\w+"?,"?\w+"?,,,,(\d+\.\d+),(\d+\.\d+)'
  CN_DEEP_CORE_SAMPLE        = '(\d+),\d+,\d+(G..R\dS\d)-(\d+)-[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    date, @plot_name, @depth, @percent_n, @percent_c = ParserMatcher.parse(CN_DEEP_CORE_SAMPLE, line)
    return unless date
    year  = date[0..3].to_i
    month = date[4..5].to_i
    day   = date[6..7].to_i
    @sample_date = Date.new(year, month, day)

    @plot_name = @plot_name.gsub(/0(\d)/,'\1')
    @plot_name = @plot_name + '-' + @depth

    Plot.find_or_create_by_name(:name=>@plot_name, :study_id => 11)

    process_data
  end

end
