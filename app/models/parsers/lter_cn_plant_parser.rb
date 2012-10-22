#For parsing GLBRC plant Carbon and Nitrogen samples.
class Parsers::LTERCNPlantParser < Parsers::CNSampleParser

#  CN_PLANT_SAMPLE           = '(\d{1,2}\/\d{1,2}\/\d\d\d\d),\d+,"?(T\d\dR\d\w+)[abc]"?,\d+\.\d+,"?\w+"?,"?\w+"?,,,,(\d+\.\d+),(\d+\.\d+)'
   CN_PLANT_SAMPLE           = '(\d+),\d+,\d+(T..R\d.+)[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

  def process_line(line)
    re = Regexp.new(CN_PLANT_SAMPLE)
    if line =~ re
      year = $1[0..3].to_i
      month = $1[4..5].to_i
      day = $1[6..7].to_i
      @sample_date = Date.new(year, month, day)
      @plot_name   = $2
      @percent_n   = $3
      @percent_c   = $4

      @plot_name = @plot_name.gsub(/0(\d)/,'\1')

      Plot.find_or_create_by_name(:name=>@plot_name, :study_id => 1)

      process_data
    end
  end

end
