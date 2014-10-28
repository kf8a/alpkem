require 'csv'

module Parsers
  class LachatLysimeterLineParser

    def self.parse(line)
      data = CSV.parse(line)[0]
      return  nil unless data[1] == "Unknown"
      plot, raw_date = data[0].split(/ /)
      plot = plot[0..-2]
      nh4 = data[17].to_f
      no3 = data[30].to_f
      sample_date = Date.new(raw_date[0..3].to_i, raw_date[4..5].to_i, raw_date[6..7].to_i) if raw_date
      [sample_date, plot, nh4, no3]
    end
  end
end
