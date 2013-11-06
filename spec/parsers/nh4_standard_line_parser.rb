require File.dirname(__FILE__) + '/../../app/models/parsers/nh4_standard_line_parser.rb'

describe NH4StandardLineParser do
  it 'parses an NH4 only line' do
    first, second, nh4, no3 = NH4StandardLineParser.parse('09:54	106	4-4c	     9541	   0.104				')
    first.should    == '4'
    second.should   == '4'
    no3.should      == nil
    nh4.should      == '0.104'
  end
end
