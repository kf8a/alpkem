require 'spec_helper'

describe Parsers::GLBRCSwitchgrassCNParser do
  describe 'a line of data' do
    before do
      FactoryGirl.create(:plot, name: 'SWF1108H2')
      @parser = Parsers::FileParser.for(23,Date.today)
      @parser.process_line '20120706,42,SWF1108H2C,3.829,GLBRC12P14D6,Unknown,,,,1.1235,44.4332'
    end
    it 'has the right date' do
      @parser.sample_date.should == Date.new(2012,7,6)
    end
    it "should have the right plot" do
      @parser.sample.plot.name.should == 'SWF1108H2'
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 1.1235
      assert_includes @parser.measurements.collect {|x| x.amount}, 44.4332
    end
  end

end