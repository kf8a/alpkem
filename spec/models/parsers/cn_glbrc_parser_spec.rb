require 'spec_helper'

describe CNGLBRCParser do

  describe 'openoffice csv format' do
  before do
    @parser = FileParser.for(9,Date.today)
    @parser.process_line('20090505,10,"0905L01S01010C",15.63,12716,"Unknown",,,,0.1291,1.2557 ')
  end

  it "should have the right date" do
    assert_equal Date.new(2009, 5,5), @parser.sample.sample_date 
  end
  it "should have the right plot" do
    assert_equal 'L01S01010', @parser.sample.plot.name
  end
  it "should have the right measurement" do
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1291
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.2557
  end
 end

  describe 'excel csv format' do
  before do
    @parser = FileParser.for(9,Date.today)
    @parser.process_line('20090505,10,0905L01S01010C,15.63,12716,Unknown,,,,0.1291,1.2557')
  end

  it "should have the right date" do
    assert_equal Date.new(2009, 5,5), @parser.sample.sample_date 
  end
  it "should have the right plot" do
    assert_equal 'L01S01010', @parser.sample.plot.name
  end
  it "should have the right measurement" do
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.1291
    assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.2557
  end
  end

end
