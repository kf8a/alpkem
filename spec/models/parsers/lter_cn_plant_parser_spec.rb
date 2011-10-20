require 'spec_helper'

describe LTERCNPlantParser do

  describe 'excel csv format' do
    describe 'a line of data' do
      before do
        @parser = FileParser.for(14,Date.today)
        @parser.process_line('20070626,11,0706T01R2TRIGRA,2.816,9856,Unknown,,,,1.5809,40.7759')
      end

      it "should have the right date" do
        assert_equal Date.new(2007,06,26), @parser.sample.sample_date 
      end
      it "should have the right plot" do
        assert_equal 'T1R2TRIGR', @parser.sample.plot.name
      end
      it "should have the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.5809
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 40.7759
      end
    end
  end

  describe 'another line of data' do
    before do
      @parser = FileParser.for(14,Date.today)
      @parser.process_line('20070625,28,0706TSFR1TRIGRB,2.639,9872,Unknown,,,,1.4945,41.8258')
    end

    it "should have the right date" do
      assert_equal Date.civil(2007,06,25), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'TSFR1TRIGR', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.4945
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 41.8258
    end
  end
end

