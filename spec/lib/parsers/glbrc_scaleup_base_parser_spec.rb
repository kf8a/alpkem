require 'rails_helper'

describe Parsers::GlbrcScaleupBaseParser do
  describe 'a line of data' do
    before do
      @parser = Parsers::Parser.for(17, Date.today)
      @parser.process_line('10:49	109	M01S02025A	   18143.576171875	       0.199468508		   27428.517578125	       0.304367423	')
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('M01S02025')
    end

    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.199468508
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.304367423
    end
  end
end
