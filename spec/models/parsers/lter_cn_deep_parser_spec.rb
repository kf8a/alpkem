require 'spec_helper'

describe LterCnDeepParser do

  describe 'lter deep core data' do
    before do
      Factory.create :plot, :name => 'T06R3S3C2M'
      @parser = FileParser.for(15, Date.today)
      @parser.process_line("20100825,48,T06R3S3C2MB,17.12,LTERDC1D12,Unknown,,,,0.0261,0.1986")
    end

    it 'has the right date' do
      assert_equal Date.new(2010,8,25), @parser.sample.sample_date
    end

    it 'has the right plot' do
      assert_equal 'T06R3S3C2M', @parser.sample.plot.name
    end

    it 'has the right right measurement' do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0261
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1986
    end
  end

  describe 'a T8nt plot' do
    before do
      Factory.create :plot, :name => "T08ntR3S2C1S"
      @parser = FileParser.for(15, Date.today)
      @parser.process_line('20101029,21,T08ntR3S2C1SA,16.67,LTERDC20B9,Unknown,,,,0.0248,0.1526')
    end

    it 'has the right plot' do
      assert_equal 'T08ntR3S2C1S', @parser.sample.plot.name
    end

    it 'has the right measurements' do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0248
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1526
    end
  end

  describe 'a forest plot' do
    before do
      Factory.create :plot, :name=>'TSFR1S5C2M'
      @parser = FileParser.for(15, Date.today)
      @parser.process_line('20101027,82,TSFR1S5C2MA,18.779,LTERDC20G10,Unknown,,,,0.0045,0.0431')
    end

    it 'has the right plot' do
      assert_equal 'TSFR1S5C2M', @parser.sample.plot.name
    end

    it 'has the right measurements' do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0045
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0431
    end
  end
end
