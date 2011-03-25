#For parsing GLBRC plant Carbon and Nitrogen samples.
class GLBRCCNPlantParser < CNSampleParser

  CN_PLANT_SAMPLE           = '(\d{1,2}\/\d{1,2}\/\d\d\d\d),\d+,"?(G\d\dR\dm?\w+)[abc]"?,\d+\.\d+,"?\w+"?,"?\w+"?,,,,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(CN_PLANT_SAMPLE)

    if line =~ re
      @sample_date = $1
      @plot_name   = $2
      @percent_n   = $3
      @percent_c   = $4

      @plot_name = @plot_name.gsub(/0/,'')

      Plot.find_or_create_by_name(:name=>@plot_name, :study_id => 8)

      process_data
    end
  end

end
