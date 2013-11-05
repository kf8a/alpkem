require 'spec_helper'

describe Parsers::SWFParser do

  describe 'a line of data' do
    before do
      FactoryGirl.create :plot, name: 'SWF404'
      @parser = Parsers::FileParser.for(18,Date.today)
      @parser.process_line('20111101,15,SWF5404H1B,,2.822,GLBRC11P16B3,Unknown,,,,0.7014,45.972')
    end

    it 'returns the right plot' do
      @parser.plot.name.should == 'SWF404'
    end

    it 'returns the right C value' do
      @parser.sample.measurements.collect {|x| x.amount}.should include(45.972)
    end

  end
end
