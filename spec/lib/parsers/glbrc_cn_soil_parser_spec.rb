require 'rails_helper'

describe Parsers::GlbrcCnSoilParser do
  before do
    @parser = Parsers::Parser.for(35, Date.today)
  end

  describe 'a line of data' do
    before do
      @parser.process_line('20150428,75,L03R1S01C1-10-C,18.236,G3SCALEUP15DCP01,Unknown,,,,0.0978,0.968')
    end

    it 'should have the right date' do
      expect(@parser.sample.sample_date).to eq(Date.civil(2015, 4, 28))
    end
    it 'should have the right plot' do
      expect(@parser.sample.plot.name).to eq('L3R1S1C1-10')
    end
    it 'should have the right measurement' do
      assert_includes @parser.measurements.collect(&:amount), 0.0978
      assert_includes @parser.measurements.collect(&:amount), 0.968
    end
  end
end
