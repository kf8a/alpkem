# frozen_string_literal: true

# (\d\d\d\d)(\d\d)(\d\d)_(\w\w)_(\w+)_(\w+-\w)_(\d+)-(\d+)_[A|B|C]

module Parsers
  class MLECNSoilFractionParser < CNSampleParser
    # PARSE_REGEX = '(\d{4})(\d{2})(\d{2})_(\w\w_\w+-n_\d+-\d+)_[A|B|C],\d+.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'
    PARSE_REGEX = '(\d{4})(\d{2})(\d{2})_(\w\w)_(\w\d\d?)(R\d)_(\w+-n)_(\d+)-(\d+)_(\w+)_[A|B|C],\d+.\d+,\w+,\w+,,,,(\d+\.\d+),(\d+\.\d+)'

    def process_line(line)
    year, month, day, site, treatment, replicate, subplot, top_depth, bottom_depth, fraction, @percent_n, @percent_c = ParserMatcher.parse(PARSE_REGEX, line)
    return unless year

    p [year, month, day, treatment, replicate, subplot, top_depth, fraction, @percent_n, @percent_c]
    @sample_date = Date.new(year.to_i, month.to_i, day.to_i)

    @plot_name = "#{site}_#{treatment}#{replicate}#{subplot}_#{top_depth}-#{bottom_depth}_#{fraction}"
    metadata = {site: site, subplot: subplot, top_depth: top_depth, treatment: treatment, replicate: replicate,
                bottom_depth: bottom_depth, fraction: fraction}
    Plot.find_or_create_with_metadata(name: @plot_name, study_id: 13, metadata: metadata)
    process_data
    end
  end
end


