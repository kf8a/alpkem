require 'rails_helper'

describe Parsers::FileParser do

  before(:each) do
    @parser = Parsers::Parser.for(9, Date.today)
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

  it 'should create a new sample if there is not one already' do
    @parser.find_plot('T1R1')
    @parser.create_sample
    sample = @parser.sample
    @parser.find_plot('T2R1')
    @parser.find_or_create_sample
    sample = @parser.sample
  end
end
