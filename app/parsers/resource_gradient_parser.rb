class Parsers::ResourceGradientParser < Parsers::FileParser
  GENERIC_SAMPLE     = '(\d{3})\s+(F\d)\s+\d+\s+(-*\d+\.\d+)\s+\d+\s*-*\d+\s*(-*\d+\.\d+)'

  def parse_data(data)
    data.each { | line | process_line(line) }
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def process_line(line)
    plot, fert, nh4, no3 = ParserMatcher.parse(GENERIC_SAMPLE, line)
    return unless plot

    find_plot("F#{plot}")
    process_nhno_sample(nh4, no3) 
  end
end
