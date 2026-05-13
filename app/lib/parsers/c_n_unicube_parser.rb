# frozen_string_literal: true

module Parsers
  class CNUnicubeParser < CNSampleParser
    def process_line(line)
      Logger.new(STDOUT).info("Processing line: #{line}")
      _weight, name, method, _area_n, _area_c, _factor_n, _factor_c, @percent_n, @percent_c, _rest = CSV.parse_line(line)
      # return unless the method is either plant or soil
      return unless method.include?('Plant')
      return if name == 'Name'
      return unless name.include?('-')

      # sometimes we have 3 parts other times we have 4 parts as in the strip samples
      result = name.split('-')
      date, @plot_name, species = if result.length == 3
                                    [result[0], result[1], result[2]]
                                  elsif result.length == 4
                                    [result[0], "#{result[1]}.#{result[2]}", result[3]]
                                  end

      # return unless @plot_name.start_with?('T')

      year = date[0..3].to_i
      month = date[4..5].to_i
      day = date[6..7].to_i
      @sample_date = Date.new(year, month, day)

      fraction = nil
      # drop the last letter of the species usually A, B, C if it is present
      species = species.slice(0, species.length - 1) if species.end_with?('A', 'B', 'C')
      species, fraction = species.split('.') if species.include?('.')
      @plot_name = @plot_name.gsub(/0(\d)/, '\1')
      study = if @plot_name.start_with?('T')
                Study.find_by(name: 'LTER')
              elsif @plot_name.start_with?('G')
                Study.find_by(name: 'GLBRC')
              elsif @plot_name.start_with?('ASP')
                Study.find_by(name: 'LTAR')
              elsif @plot_name.start_with?('BAF')
                Study.find_by(name: 'LTAR')
              else
                raise "Unknown study for plot #{@plot_name}"
              end
      fraction_string = fraction ? ".#{fraction}" : ''
      @plot_name = "#{@plot_name}-#{species}#{fraction_string}"

      # plot = Plot.find_or_create_by(name: @plot_name, study_id: 1)
      plot = Plot.find_or_create_by(name: @plot_name, study_id: study.id)
      return unless plot

      process_data
    end
  end
end
