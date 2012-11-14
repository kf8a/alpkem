class FileFormatSelector

  def get_line_parser_prefix(data)
    lines = data.readlines
    data.rewind

    header = analysis_header_line(lines)
    case header
    when /NH4.+NO3/ then 
      ''
    when /NH4/ then
      'NH4'
    when /NO3/ then 
      'NO3'
    else
      raise 'Unkown file type'
    end

  end

  private
  def analysis_header_line(lines)
    i = 0
    lines.each do |line|
      break if line =~ /Time acquired/
      i = i + 1
    end
    lines[i + 2]
  end

end
