require 'rails_helper'

describe Parsers::LterCnDeepParser do

  describe 'lter deep core data' do
    before do
      FactoryGirl.create :plot, name: "T04R5S4C2M"
      @parser = Parsers::Parser.for(15, Date.today)
      @parser.process_line("20130904,10,T04R5S4C2-55-C,17.247,LTERDC2013P02A10,Unknown,,,,0.0159,0.1342")
      # @parser.process_line("20100825,48,T06R3S3C2MB,17.12,LTERDC1D12,Unknown,,,,0.0261,0.1986")
    end

    it 'has the right date' do
      assert_equal Date.new(2013,9,4), @parser.sample.sample_date
    end

    it 'has the right plot' do
      assert_equal 'T04R5S4C2M', @parser.sample.plot.name
    end

    it 'has the right right measurement' do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0159
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1342
    end
  end

  describe 'a T8nt plot' do
    before do
      FactoryGirl.create :plot, :name => "T08ntR5S4C2S"
      @parser = Parsers::Parser.for(15, Date.today)
      @parser.process_line("20130904,10,T08ntR5S4C2-10-C,17.247,LTERDC2013P02A10,Unknown,,,,0.0159,0.1342")
    end

    it 'has the right plot' do
      assert_equal 'T08ntR5S4C2S', @parser.sample.plot.name
    end
  end

  describe 'a forest plot' do
    before do
      FactoryGirl.create :plot, :name=>'TSFR1S5C2M'
      @parser = Parsers::Parser.for(15, Date.today)
      @parser.process_line("20130904,10,TSFR1S5C2-55-C,17.247,LTERDC2013P02A10,Unknown,,,,0.0159,0.1342")
    end

    it 'has the right plot' do
      assert_equal 'TSFR1S5C2M', @parser.sample.plot.name
    end

  end
end
