require 'rails_helper'

describe Parsers::GenericParser do

  before do
    find_or_factory :plot, name: 'G1R1-10'
    @parser = Parsers::Parser.for(20,Date.today)
  end
  describe 'a line of data' do
    before do
      @parser.process_line('10:34	113	20130708G1R1-10-a	     9104	   0.068					   288371	   2.954',Parsers::GenericLineParser)
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('G1R1-10')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.068
      assert_includes @parser.measurements.collect {|x| x.amount}, 2.954
    end
  end

  describe 'a line of non data' do
    before do
      @parser.process_line('14:26	266	1 M KCl	      376	  -0.010	LO				      -76	   0.021		', Parsers::GenericLineParser)
    end

    it "should have no plot" do
      expect(@parser.sample).to be_nil
    end
  end

end
