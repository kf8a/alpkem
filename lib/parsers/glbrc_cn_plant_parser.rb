#For parsing GLBRC plant Carbon and Nitrogen samples.
module Parsers
  class GLBRCCNPlantParser < CNSampleParser

    # CN_PLANT_SAMPLE           = '(\d{1,2}\/\d{1,2}\/\d\d\d\d),\d+,"?(G\d\dR\dm?\w+)[abc]"?,\d+\.\d+,"?\w+"?,"?\w+"?,,,,(\d+\.\d+),(\d+\.\d+)'
    CN_PLANT_SAMPLE           = '(\d+),\d+,\d+(G..R\d.+)[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
      date, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(CN_PLANT_SAMPLE, line)
      return unless date
      year  = date[0..3].to_i
      month = date[4..5].to_i
      day   = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      @plot_name = @plot_name.gsub(/0(\d)/,'\1')

      Plot.find_or_create_by(name: @plot_name, study_id: 8)

      process_data
    end

  end
end
