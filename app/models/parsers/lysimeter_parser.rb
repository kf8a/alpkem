#For parsing Lysimeter samples
class Parsers::LysimeterParser < Parsers::FileParser

  def parse_data(data)
    line_parser = check_file_type(data)

    data.each { | line | process_line(line, line_parser) }
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def analysis_header_line(lines)
    i = 0
    lines.each do |line|
      break if line =~ /Time acquired/
      i = i + 1
    end
    lines[i + 2]
  end

  def check_file_type(data)
    lines = data.readlines
    data.rewind

    header = analysis_header_line(lines)
    case header
    when /NH4.+NO3/ then 
      LysimeterLineParser
    when /NH4/ then
      NH4LysimeterLineParser
    when /NO3/ then 
      NO3LysimeterLineParser
    else
      raise 'Unkown file type'
    end

  end

  def process_line(line, line_parser)
    first, second, third, raw_date, nh4_amount, no3_amount = line_parser.parse(line)
    unless first.blank? || second.blank? || third.blank?
      locate_plot(first, second, third)

      process_data(nh4_amount, no3_amount)
    end
  end

  def locate_plot(first, second, third)
    plot_name = "T#{first}R#{second}F#{third}"
    find_plot(plot_name) unless self.plot.try(:name) == plot_name
  end

  def process_data(nh4_amount, no3_amount)
    process_nhno_sample(nh4_amount, no3_amount) if plot.present?
  end

end
