require 'csv'

class FileFormatSelector
  def get_line_parser_prefix(data)
    lines = data.readlines
    data.rewind

    if lachat_format?(lines)
      'Parsers::Lachat'
    elsif old_format?(lines)
      'Parsers::Old'
    else
      name = 'Parsers::'
      header = analysis_header_line(lines)
      case header
      when /NH4.+NO3/ then
        name + ''
      when /NH4/ then
        name + 'NH4'
      when /NO3/ then
        name + 'NO3'
      else
        raise 'Unkown file type'
      end
    end
  end

  private

  def analysis_header_line(lines)
    i = 0
    lines.each do |line|
      break if line =~ /Time acquired/
      i += 1
    end
    lines[i + 2]
  end

  def lachat_format?(lines)
    first_line = CSV.parse(lines[0]).first
    first_line.first == 'Sample ID'
  end

  def old_format?(lines)
    is_old_format = true
    lines.each do |line|
      if line =~ /^\tResult/
        is_old_format = false
      end
    end
    is_old_format
  end
end
