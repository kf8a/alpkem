require 'spec_helper'

describe Parsers::GenericParser do

  describe 'a line of data' do
    before do
      FactoryGirl.create(:plot, name: 'G1R1-10')
      @parser = Parsers::FileParser.for(20,Date.today)
      @parser.process_line('10:34	113	20130708G1R1-10-a	     9104	   0.068					   288371	   2.954',GenericLineParser)
    end

    it "should have the right plot" do
      @parser.sample.plot.name.should == 'G1R1-10'
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.068
      assert_includes @parser.measurements.collect {|x| x.amount}, 2.954
    end
  end

end
