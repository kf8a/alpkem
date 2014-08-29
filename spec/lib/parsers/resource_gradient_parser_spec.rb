require 'rails_helper'

describe Parsers::ResourceGradientParser do
  before do
    FactoryGirl.create(:plot, name: 'F403')
    @parser = Parsers::Parser.for(22,Date.today)
  end
  describe 'processing a line of data' do
    before do
      @parser.process_line('13:40	188	Sample ID:  403   F4	    21017	   0.124					    14794	   0.154				')
    end

    it 'has the right plot' do
      expect(@parser.sample.plot.name).to eql('F403')
    end

    it 'has the right measurements' do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.154
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.124
    end
  end

  describe 'processing a line of non-data' do
    before do
      @parser.process_line('13:40	188	Sample ID:  403   ')
    end

    it 'has no plot' do
      expect(@parser.sample).to be_nil
    end
  end
end
