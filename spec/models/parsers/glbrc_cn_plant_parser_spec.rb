require 'spec_helper'

describe GLBRCCNPlantParser do

  describe 'an excel file with improper string escaping' do
    before do
      @parser = FileParser.for(12,Date.today)
      @parser.process_line('20081010,12,0810G01R2ZEAGRB,3.832,GLBRC08P01A12,Unknown,,,,1.9310,40.6730')
    end

    it "should have the right date" do
      assert_equal Date.civil(2008,10,10), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'G1R2ZEAGR', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 40.6730
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.9310
    end
  end

  describe 'another MSExcel line' do
    before do
      @parser = FileParser.for(12,Date.today)
      @parser.process_line('20081010,68,0810G02R2ZEASTC,2.592,GLBRC08P01F8,Unknown,,,,0.8120,43.4679')
    end

    it "should have the right date" do
      assert_equal Date.civil(2008,10,10), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'G2R2ZEAST', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 43.4679
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.8120
    end
  end
end

