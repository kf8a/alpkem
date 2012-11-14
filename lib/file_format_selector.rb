class FileFormatSelector

  def get_line_parser_prefix(data)
    lines = data.readlines
    data.rewind

    if old_format?(lines)
      '2005'
    else

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
