require 'spec_helper'

describe LterCnDeepParser do

  describe 'lter deep core data' do
    before do
      Factory.create :plot, :name => 'T06R3S3C2MB'
      @parser = FileParser.for(15, Date.today)
      @parser.process_line("20100825,48,T06R3S3C2MB,17.12,LTERDC1D12,Unknown,,,,0.0261,0.1986")
    end

    it 'has the right date' do
      assert_equal Date.new(2010,8,25), @parser.sample.sample_date
    end

    it 'should have the right plot' do
      assert_equal 'T06R3S3C2M', @parser.sample.plot.name
    end

    it 'has the right right measurement' do
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.0261
      assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1986
    end
  end
end
