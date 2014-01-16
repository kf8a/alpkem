# require File.dirname(__FILE__) + '/../../app/parsers/resource_gradient_parser.rb'
# require File.dirname(__FILE__) + '/../../lib/parser_matcher.rb'
require 'spec_helper'

describe Parsers::ResourceGradientParser do
    before do
      FactoryGirl.create(:plot, name: '403')
      @parser = Parsers::FileParser.for(22,Date.today)
      @parser.process_line('13:40	188	Sample ID:  403   F4	    21017	   0.124					    14794	   0.154				')
    end

    it 'has the right plot' do
      @parser.sample.plot.name.should == '403'
    end

    it 'has the right measurements' do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.154
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.124
    end
end
