require 'spec_helper'

describe Parsers::StandardParser do
  describe 'a line of lter data' do
    before do
      @parser = Parsers::FileParser.for(2,Date.today)
      @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				', StandardLineParser)
    end

    it "should have the right plot" do
      @parser.sample.plot.name.should == 'T2R1'
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
    end
  end

  describe 'a line of glbrc data' do
    before do
      @parser = Parsers::FileParser.for(8,Date.today)
      @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				', StandardLineParser)
    end

    it "should have the right plot" do
      @parser.sample.plot.name.should == 'G2R1'
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
    end
  end

  describe 'a line of junk' do
    before do
      @parser = Parsers::FileParser.for(2,Date.today)
      @parser.process_line('10:38	bad-1a	     6282	   0.048					    74108	   0.714				', StandardLineParser)
    end

    it "should return no sample" do
      @parser.sample.should be_nil
    end
  end
end
