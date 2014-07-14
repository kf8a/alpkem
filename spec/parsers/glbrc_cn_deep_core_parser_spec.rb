require 'spec_helper'

describe Parsers::GLBRCCNDeepCoreParser do

  before do
    @parser = Parsers::FileParser.for(26,Date.today)
  end
  describe 'a line of data' do
    before do
      @parser.process_line('20131114,15,20131114G01R1S1-50-B,16.982,B3GLBRC13DCP01,Unknown,,,,0.0368,0.2617')
    end

    it "should have the right date" do
      expect(@parser.sample.sample_date).to eq(Date.civil(2013,11,14))
    end
    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eq('G1R1S1-50')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.0368
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.2617
    end
  end

  describe 'a line of non data' do
    before do
      @parser.process_line 'Material for Analysis:  plants,,,Calibration Standard: Acetanilide,,Plate Label: GLBRC12 P04,,,,,'
    end

    it 'should not find a sample' do
      expect(@parser.sample).to be_nil
    end
  end

end

