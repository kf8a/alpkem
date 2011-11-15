require 'spec_helper'

describe CNDeepParser do

  describe 'openoffice csv format' do
  before do
    @parser = FileParser.for(7,Date.today)
    @parser.process_line('20090424,9,"09DCL01S01010B",18.456,13555,"Unknown",,,,0.1558,1.5256')
  end

  it "should have the right date" do
    assert_equal Date.new(2009, 4,24), @parser.sample.sample_date 
  end
  it "should have the right plot" do
    assert_equal 'L01S01010', @parser.sample.plot.name
  end
  it "should have the right measurement" do
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1558
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.5256
  end
  end


  describe 'excel csv format' do
  before do
    @parser = FileParser.for(7,Date.today)
    @parser.process_line('20090424,9,09DCL01S01010B,18.456,13555,Unknown,,,,0.1558,1.5256')
  end

  it "should have the right date" do
    assert_equal Date.new(2009, 4,24), @parser.sample.sample_date 
  end
  it "should have the right plot" do
    assert_equal 'L01S01010', @parser.sample.plot.name
  end
  it "should have the right measurement" do
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1558
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.5256
  end
  end
end
