# frozen_string_literal: true

module Parsers
  # For parsing GLBRC plant Carbon and Nitrogen samples.
  class LterCnPlantParser < CNSampleParser
    CN_PLANT_SAMPLE =
      '(\d+),\d+,(\d+)?(T..R\d(?:N\d)?)-(.+)[abc|ABC],\d+\.\d+,\w+,\w+,,,,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      date, _x, @plot_name, species, @percent_n, @percent_c = ParserMatcher.parse(CN_PLANT_SAMPLE, line)
      if date
        year = date[0..3].to_i
        month = date[4..5].to_i
        day = date[6..7].to_i
        @sample_date = Date.new(year, month, day)

        @plot_name = @plot_name.gsub(/0(\d)/,'\1')
        @plot_name = @plot_name + '-' + species

        plot = Plot.find_or_create_by(name: @plot_name, study_id: 1)
        plot.species_code = species
        plot.save

        process_data
      end
    end
  end
end
