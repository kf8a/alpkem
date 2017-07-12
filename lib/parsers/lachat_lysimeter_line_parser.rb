require 'csv'

module Parsers

  class LachatLysimeterLineParser
    def self.parse(line)
      data = CSV.parse(line)[0]
      p data
      return nil unless data[1] == 'Unknown'
      return nil if data[0] =~ /1\s.M\s+KCL/i
      return nil if data[0] =~ /H2O/i
      plot, raw_date = data[0].split(/\s+/)
      p [plot, raw_date]
      first, second, third = plot[0..-2].split(/-/)

      manual_dilution_factor = data[5].to_f
      auto_dilution_factor = data[6].to_f
      dilution_factor = manual_dilution_factor * auto_dilution_factor

      nh4 = data[nh4_id(data)].to_f * dilution_factor
      no3 = data[no3_id(data)].to_f * dilution_factor
      sample_date = parse_date(raw_date)
      [first, second, third, sample_date, nh4, no3]
    end

    def self.parse_date(raw_date)
      return unless raw_date
      Date.new(raw_date[0..3].to_i,
               raw_date[4..5].to_i,
               raw_date[6..7].to_i)
    end

    def self.nh4_id(data)
      if data[16] == 'Ammonia'
        17
      elsif data[29] == 'Ammonia'
        30
      else
        200
      end
    end

    def self.no3_id(data)
      if data[16] == 'Nitrate-Nitrite'
        17
      elsif data[29] == 'Nitrate-Nitrite'
        30
      else
        200
      end
    end
  end
end
