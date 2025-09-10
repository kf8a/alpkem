# frozen_string_literal: true

module Parsers
  #For parsing soil Carbon/Nitrogen samples from GLBRC.
  class CNGlbrcBarcodeParser < CNSampleParser

    BARCODE= '(FS\d+),.+,(\d+(?:\.\d+)?),(\d+(?:\.\d+)?)'

    def process_line(line)
      @plot_name, @percent_n, @percent_c = ParserMatcher.parse(BARCODE, line)
      process_data
    end

    def process_data
      process_cn_sample
    end
  end
end
