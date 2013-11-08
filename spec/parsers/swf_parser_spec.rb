require 'spec_helper'

describe Parsers::SWFParser do

    before do
      @parser = Parsers::FileParser.for(18,Date.today)
    end
  describe 'a line of data' do
    before do
      FactoryGirl.create :plot, name: 'SWF404'
      @parser.process_line('20111101,15,SWF5404H1B,,2.822,GLBRC11P16B3,Unknown,,,,0.7014,45.972')
    end

    it 'returns the right plot' do
      @parser.plot.name.should == 'SWF404'
    end

    it 'returns the right C value' do
      @parser.sample.measurements.collect {|x| x.amount}.should include(45.972)
    end
  end

  describe 'another line of data' do
    before do 
      FactoryGirl.create :plot, name: 'SWF201'
      @parser.process_line('20120706,44,SWF1201H2B,3.037,GLBRC12P14D8,Unknown,,,,1.1108,44.82')
    end

    it 'returns the right plot' do
      @parser.plot.name.should == 'SWF201'
    end
  end

  describe 'a standard line' do
    it 'returns no plot' do
      @parser.process_line('20131021,72,Blind Standard,3.507,GLBRC12P14F12,Unknown,,,,1.3991,40.5156')
      @parser.plot.should be_nil
    end
  end

  describe 'an empty line' do
    it 'returns no plot' do
      @parser.process_line('')
      @parser.plot.should be_nil
    end
  end
end
