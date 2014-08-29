module Parsers
  # parsing leilei's samples
  class LeileiSampleParser < FileParser

    LEILEI_SAMPLE = '\t\d{3}\t(\w\d+\w\d*-\d)\s+(\d+/\d+/\d+)\s+\d+\s+(-*\d\.\d+)\s+\d+\s+(-*\d+\.\d+)'

    def process_line(line)
      re = Regexp.new(LEILEI_SAMPLE)

      if line =~ re
        nh4_amount = $3
        no3_amount = $4

        plot = $1
        date = $2

        self.sample_date = Chronic.parse(date).to_date
        #try to find plot
        self.plot = Plot.find_by_name(plot)
        #create it if you can't find it
        self.plot = Plot.create(:name => plot) if self.plot.blank?

        process_nhno_sample(nh4_amount, no3_amount)
      end
    end
  end
end
