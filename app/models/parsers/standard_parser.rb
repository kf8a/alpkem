#Generic parser to convert files to measurements.
class Parsers::StandardParser < Parsers::FileParser

  def parse_data(data)
    line_parser = check_file_type(data)

    data.each { | line | process_line(line, line_parser) }
    if self.measurements.blank?
      self.load_errors += "No data was able to be loaded from this file."
    end
  end

  def check_file_type(data)
    lines = data.readlines
    data.rewind

    case lines[15]
    when /NH4.+NO3/ then 
      StandardLineParser
    when /NH4/ then
      NH4LineParser
    when /NO3/ then 
      NO3LineParser
    else
      raise 'Unkown file type'
    end

  end

  def process_line(line, line_parser)
    first, second, nh4_amount, no3_amount = line_parser.parse(line)
 
    unless first.blank? || second.blank?
      plot_name = get_plot_name(first, second)
      unless plot.try(:name) == plot_name
        find_plot(plot_name) 
      end
      process_nhno_sample(nh4_amount, no3_amount) if plot.present?
    end
  end

  def get_plot_name(first, second)
    if @sample_type_id == 2
      "T#{first}R#{second}"
    elsif first.start_with?("L0") || first.start_with?("M0")
      "#{first}S#{second}"
    else
      "G#{first}R#{second}"
    end
  end

end
