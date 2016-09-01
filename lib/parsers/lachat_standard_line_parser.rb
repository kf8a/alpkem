require 'csv'

module Parsers
  class LachatStandardLineParser

    def self.parse(line)
      data = CSV.parse_line(line)

      return  nil unless data[1] == "Unknown"
      return nil if data[0] =~ /1\s*M\s+KCL/i
      return nil if data[0] =~ /H2O/i
      return nil if data[0] =~ /blank/i
      return nil if data[0] =~ /BLK/i

      result = /([A-Z]{3})?-?(\d{8})-?(\w+)R(\d).-?(\d+)?/.match(data.first)
      raise "unparsable name #{data.first}" unless result
      raw_date = result[2]
      first = result[3]
      second = result[4]
      modifier = result[5]
      site = result[1]

      manual_dilution_factor = data[5].to_f
      auto_dilution_factor = data[6].to_f
      dilution_factor = manual_dilution_factor * auto_dilution_factor

      nh4 = data[17].to_f * dilution_factor
      no3 = data[30].to_f * dilution_factor
      sample_date = Date.new(raw_date[0..3].to_i, raw_date[4..5].to_i, raw_date[6..7].to_i) if raw_date

      [first, second, nh4, no3, sample_date, modifier, site]
    end
  end
end
