# frozen_string_literal: true

require "csv"

module Parsers
  # Generic parser for lachat data
  class LachatGenericLineParser
    PLOT_PARSER =
      '(?<date>\d{8})(?<plot>(\w\w)?[G|L|M|T]\w+)(?<rep>R\d+)?(?<modifier>\w+)?-(?<depth>\d+)'

    def self.parse(line)
      data = CSV.parse_line(line)

      return nil unless data[1] == "Unknown"

      return nil if blank?(data)

      # attempt to parse the plot to prevent odd plots from getting into the db
      regex = Regexp.new(PLOT_PARSER)
      result = data.first.match(regex)
      raise "unparsable name #{data.first}" unless result

      raw_date = result[:date]
      my_plot = "#{result[:plot]}#{result[:rep]}#{result[:modifier]}"
      p "Plot #{my_plot}"

      manual_dilution_factor = data[5].to_f
      auto_dilution_factor = data[6].to_f
      dilution_factor = manual_dilution_factor * auto_dilution_factor

      nh4 = if data[16] == "Ammonia"
              data[17].to_f * dilution_factor
            elsif data[29] == "Ammonia"
              data[30].to_f * dilution_factor
            end

      no3 = if data[16] == "Nitrate-Nitrite"
              data[17].to_f * dilution_factor
            elsif data[29] == "Nitrate-Nitrite"
              data[30].to_f * dilution_factor
            end

      # nh4 = data[17].to_f * dilution_factor
      # no3 = data[30].to_f * dilution_factor
      sample_date = Date.new(raw_date[0..3].to_i, raw_date[4..5].to_i, raw_date[6..7].to_i) if raw_date

      [sample_date, my_plot, result[:depth], nh4, no3]
    end

    def self.blank?(data)
      data[0] =~ /1\s*M\s+KCL/i || data[0] =~ /H2O/i || data[0] =~ /blank/i || data[0] =~ /BLK/i
    end
  end
end
