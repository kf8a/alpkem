require 'spec_helper'

describe GLBRCCNPlantParser do

  describe 'openoffice csv format' do
    describe 'a line of data' do
      before do
        @parser = FileParser.for(12,Date.today)
        @parser.process_line('11/11/2010,11,"G05R2PANVIa",2.805,"GLBRC10JS1A11","Unknown",,,,0.7185,46.7738')
      end

      it "should have the right date" do
        assert_equal Date.new(2010,11,11), @parser.sample.sample_date 
      end
      it "should have the right plot" do
        assert_equal 'G5R2PANVI', @parser.sample.plot.name
      end
      it "should have the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 46.7738
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.7185
      end
    end
  end

  describe 'another line of data' do
    before do
      @parser = FileParser.for(12,Date.today)
      @parser.process_line('11/9/2010,53,"G07R5mCOMBMa",3.673,"GLBRC10JS2E5","Unknown",,,,0.6157,45.2636')
    end

    it "should have the right date" do
      assert_equal Date.civil(2010,11,9), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'G7R5mCOMBM', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 45.2636
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.6157
    end
  end

  describe 'another line of data' do
    before do
      @parser = FileParser.for(12,Date.today)
      @parser.process_line('11/11/2010,83,G10R4COMBMb,2.918,GLBRC10JS1G11,Unknown,,,,0.5135,47.1139')
    end

    it "should have the right date" do
      assert_equal Date.civil(2010,11,11), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'G10R4COMBM', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 47.1139
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.5135
    end
    
  end

  describe 'an excel file with improper string escaping' do
    before do
      @parser = FileParser.for(12,Date.today)
      @parser.process_line('11/11/2010,11,G05R2PANVIa,2.805,GLBRC10JS1A11,Unknown,,,,0.7185,46.7738')
    end

    it "should have the right date" do
      assert_equal Date.civil(2010,11,11), @parser.sample.sample_date 
    end
    it "should have the right plot" do
      assert_equal 'G5R2PANVI', @parser.sample.plot.name
    end
    it "should have the right measurement" do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 46.7738
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.7185
    end
  end
end

