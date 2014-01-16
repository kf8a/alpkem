require File.dirname(__FILE__) + '/../../app/parsers/resource_gradient_line_parser.rb'
require File.dirname(__FILE__) + '/../../lib/parser_matcher.rb'

describe ResourceGradientLineParser do
  it 'parser a line' do
    plot, second, nh4, no3 = ResourceGradientLineParser.parse('13:40	188	Sample ID:  403   F4	    21017	   0.124					    14794	   0.154				')
    plot.should == '403'
    nh4.should == '0.124'
    no3.should == '0.154'
  end
end
