# frozen_string_literal: true

module Parsers
  class CNUnicubeParser < CNSampleParser
    def process_line(line)
      _weight, name, method, _area_n, _area_c, _factor_n, _factor_c, @percent_n, @percent_c, _rest = CSV.parse_line(line)
      # return unless the method is either plant or soil
      return unless method.include?("Plant")
      return if name == "Name"
      return unless name.include?('-')

      date, @plot_name, species = name.split('-')
      p [date, @plot_name, species]
      return unless @plot_name.start_with?('T')

      year = date[0..3].to_i
      month = date[4..5].to_i
      day = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      fraction = nil
      if species.include?('.')
        species, fraction = species.split('.')
      end
      @plot_name = @plot_name.gsub(/0(\d)/,'\1')
      @plot_name = @plot_name + '-' + species + (fraction ? '.' + fraction : '')

      plot = Plot.find_or_create_by(name: @plot_name, study_id: 1)
      plot.species_code = species
      plot.fraction = fraction
      plot.save
      process_data
    end
  end
end