require "csv"

module Parsers
  class LtarSoilParser
     PLOT_PARSER = '(\d+)-(\w+\d)(R\d)-(\w+)-(\d+)'

    def self.parse(data)
     regex = Regexp.new(PLOT_PARSER)
     result = data.first.match(regex)
     raise "unparsable name #{data.first}" unless result
     raw_date = result[:date]
     my_plot = "#{result[:plot]}#{result[:rep]}#{result[:modifier]}"
     
    end
  end
end
