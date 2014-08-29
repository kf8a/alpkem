require 'rails_helper'

describe Parsers::GLBRCCNPlantParser do

  describe 'an excel file with improper string escaping' do
    before do
      @parser = Parsers::Parser.for(12,Date.today)
    end
    describe 'a line of data' do
      before do
        @parser.process_line('20081010,12,0810G01R2ZEAGRB,3.832,GLBRC08P01A12,Unknown,,,,1.9310,40.6730')
      end

      it "should have the right date" do
        expect(@parser.sample.sample_date).to eql(Date.civil(2008,10,10))
      end
      it "should have the right plot" do
        expect(@parser.sample.plot.name).to eql('G1R2ZEAGR')
      end
      it "should have the right measurement" do
        assert_includes @parser.measurements.collect {|x| x.amount}, 40.6730
        assert_includes @parser.measurements.collect {|x| x.amount}, 1.9310
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

    describe 'another MSExcel line' do
      before do
        @parser.process_line('20081010,68,0810G02R2ZEASTC,2.592,GLBRC08P01F8,Unknown,,,,0.8120,43.4679')
      end

      it "should have the right date" do
        expect(@parser.sample.sample_date).to eql(Date.civil(2008,10,10))
      end
      it "should have the right plot" do
         expect(@parser.sample.plot.name).to eql('G2R2ZEAST')
      end
      it "should have the right measurement" do
        assert_includes @parser.measurements.collect {|x| x.amount}, 43.4679
        assert_includes @parser.measurements.collect {|x| x.amount}, 0.8120
      end
    end

    describe 'a line with a fraction' do
      before do
        @parser.process_line('20081010,68,0810G02R2ZEAMX.GRA,2.592,GLBRC08P01F8,Unknown,,,,0.8120,43.4679')
      end

      it 'has the right date' do
        expect(@parser.sample.sample_date).to eql(Date.civil(2008,10,10))
      end
      it "should have the right plot" do
         expect(@parser.sample.plot.name).to eql('G2R2ZEAMX.GR')
      end
      it "should have the right measurement" do
        assert_includes @parser.measurements.collect {|x| x.amount}, 43.4679
        assert_includes @parser.measurements.collect {|x| x.amount}, 0.8120
      end
    end

    describe 'a poplar line' do
      before do
        @parser.process_line('20101221,51,1012G08R4POPNXM.TRB,2.753,GLBRC10P06E3,Unknown,,,,0.4198,46.9426')
      end

      it 'has the right date' do
        expect(@parser.sample.sample_date).to eql(Date.civil(2010,12,21))
      end

      it 'has the right plot' do
        expect(@parser.sample.plot.name).to eql('G8R4POPNXM.TR')
      end
    end
  end
end

