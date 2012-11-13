require 'spec_helper'

describe Parsers::StandardParser do
    before do
      @parser = Parsers::FileParser.for(2,Date.today)
    end
    describe 'a line of data' do
      before do
        @parser.process_line('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				')
      end

      it "should have the right plot" do
        @parser.sample.plot.name.should == 'T2R1'
      end
      it "should have the right measurement" do
        assert_includes @parser.measurements.collect {|x| x.amount}, 0.048
        assert_includes @parser.measurements.collect {|x| x.amount}, 0.714
      end
  end
end
