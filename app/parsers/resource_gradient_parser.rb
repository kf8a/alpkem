class Parsers::ResourceGradientParser < Parsers::FileParser
  GENERIC_SAMPLE     = '(\d{3})\s+(F\d)\s+\d+\s+(-*\d+\.\d+)\s+\d+\s*-*\d+\s*(-*\d+\.\d+)'

  def process_line(line)
    plot, fert, nh4, no3 = ParserMatcher.parse(GENERIC_SAMPLE, line)

    find_plot(plot)
    process_nhno_sample(nh4, no3)
  end
end
