require 'rails_helper'

describe Parsers::GLBRCCNRootSoilParser do
  before do
    @parser = Parsers::Parser.for(40, Date.today)
  end

  describe 'a line of data' do
    before do
      @parser.process_line('20171207,10,G5R2CC-10-C,4.749,A10GLBRC2017rootsP01,Unknown,,,,1.0275,46.0993')
    end

    it 'should have the right date' do
      expect(@parser.sample.sample_date).to eq(Date.civil(2017, 12, 7))
    end
    it 'should have the right plot' do
      expect(@parser.sample.plot.name).to eq('G5R2CC-10')
    end
    it 'should have the right measurement' do
      assert_includes @parser.measurements.collect(&:amount), 1.0275
      assert_includes @parser.measurements.collect(&:amount), 46.0993
    end
  end
end



