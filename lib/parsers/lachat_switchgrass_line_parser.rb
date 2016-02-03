require 'csv'

module Parsers
  class LachatSwitchgrassLineParser
    def self.parse(line)
      data = CSV.parse_line(line)

      return  nil unless data[1] == "Unknown"
      return nil if data[0] =~ /1\s*M\s+KCL/i
      return nil if data[0] =~ /H2O/i
      return nil if data[0] =~ /blank/i
      return nil if data[0] =~ /BLK/i

      result = /([A-Z]{3})-(\d{8})-(\w+)R(\d)C-(\d+)/.match(data.first)
      raise "unparsable name #{data.first}" unless result
      raw_date = result[2]
      first = result[3]
      second = result[4]
      site = result[1]

      nh4 = data[17].to_f
      no3 = data[30].to_f
      sample_date = Date.new(raw_date[0..3].to_i, raw_date[4..5].to_i, raw_date[6..7].to_i) if raw_date

      [first, second, nh4, no3, sample_date, site]
    end
  end
end
