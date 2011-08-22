require 'spec_helper'

describe FileParser do

  before(:each) do
    @parser = FileParser.for(9, Date.today)
  end

  it "should return the right sample on find_sample and find_or_create_sample" do
    @parser.find_plot('T1R1')
    @parser.create_sample
    sample = @parser.sample
    @parser.find_sample
    assert_equal sample, @parser.sample
    @parser.find_or_create_sample
    assert_equal sample, @parser.sample
  end

end