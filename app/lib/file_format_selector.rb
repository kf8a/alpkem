# frozen_string_literal: true

require "csv"

# select the correct parser for each data file
class FileFormatSelector
  def get_line_parser_prefix(data)
    lines = data.readlines
    data.rewind

    if lachat_format?(lines)
      "Parsers::Lachat"
    elsif old_format?(lines)
      "Parsers::Old"
    else
      name = "Parsers::"
      header = analysis_header_line(lines)
      case header
      when /NH4.+NO3/
        name
      when /NH4/
        "#{name}NH4"
      when /NO3/
        "#{name}NO3"
      else
        raise "Unkown file type"
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
    first_line.first == "Sample ID"
  end

  def old_format?(lines)
    old_format = lines.map { |line| line =~ /Run Results Report/ }
    old_format.include?(0)
  end
end
