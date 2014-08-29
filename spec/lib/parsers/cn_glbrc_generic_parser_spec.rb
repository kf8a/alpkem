require 'rails_helper'

describe Parsers::CNGLBRCGenericParser do

  before do
    @parser = Parsers::Parser.for(25,Date.today)
  end
  describe 'a line of data' do
    before do
      @parser.process_line('21 20130916,17,G01R4-ZEAMXa,2.597,GLBRC13BNPPP01B5,Unknown,,,,0.7525,42.5325')
    end

    it 'creates a sample' do
      expect(@parser.sample).to_not be_nil
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eq('G1R4-ZEAMX')
    end
    it 'has the right date' do
      expect(@parser.sample.sample_date).to eq(Date.new(2013,9,16))
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.7525
      assert_includes @parser.measurements.collect {|x| x.amount}, 42.5325
    end
  end

  describe 'an older line of data' do
    before do
      @parser.process_line('21 20130916,17,G01R4ZEAMXc,2.597,GLBRC13BNPPP01B5,Unknown,,,,0.7525,42.5325')
    end

    it 'creates a sample' do
      expect(@parser.sample).to_not be_nil
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eq('G1R4-ZEAMX')
    end
    it 'has the right date' do
      expect(@parser.sample.sample_date).to eq(Date.new(2013,9,16))
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.7525
      assert_includes @parser.measurements.collect {|x| x.amount}, 42.5325
    end
  end

  describe 'a line of non data' do
    before do
      @parser.process_line('20140331,4,Standard2,0.532,GLBRC13BNPPP01A4Std2,Standard,2,,,7.4609,64.878')
    end

    it "should have no plot" do
      expect(@parser.sample).to be nil
    end
  end
end
