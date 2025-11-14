# frozen_string_literal: true

module Parsers
  class CNUnicubeParser < CNSampleParser
    def process_line(line)
      _weight, name, method, _area_c, _area_n, _factor_c, _factor_n, @percent_c, @percent_n, _rest = CSV.parse_line(line)
      # return unless the method is either plant or soil
      return if method != "Plant"
      return if name == "Name"
      p [name, method]

      date, @plot_name, species = name.split('-')
      return unless @plot_name.start_with?('T')

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