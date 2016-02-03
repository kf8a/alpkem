require 'csv'

class FileFormatSelector

  def get_line_parser_prefix(data)
    lines = data.readlines
    data.rewind

    if lachat_format?(lines)
      "Parsers::Lachat"
    else
      raise 'Unkown file type'
    end

  end

  private

  def lachat_format?(lines)
    first_line = CSV.parse(lines[0]).first
    first_line.first == "Sample ID"
  end

end
