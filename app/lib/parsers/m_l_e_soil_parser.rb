# frozen_string_literal: true

# (\d\d\d\d)(\d\d)(\d\d)_(\w\w)_(\w+)_(\w+-\w)_(\d+)-(\d+)_[A|B|C]

module Parsers
  class MLESoilParser < CNSampleParser
    PARSE_REGEX = '(\d{4})(\d{2})(\d{2})_(\w\w_\w+-n_\d+-\d+)_[A|B|C],\d+.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
    year, month, day, @plot_name, @percent_n, @percent_c = ParserMatcher.parse(PARSE_REGEX, line)
    return unless year

    p [year, month, day, @plot_name, @percent_n, @percent_c]
    @sample_date = Date.new(year.to_i, month.to_i, day.to_i)

    Plot.find_or_create_by(name: @plot_name, study_id: 13)
    process_data
    end
  end
end


