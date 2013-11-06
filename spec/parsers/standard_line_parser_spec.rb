require File.dirname(__FILE__) + '/../../app/models/parsers/standard_line_parser.rb'

describe StandardLineParser do
  it 'parses a soil sample lines' do
    first, second, nh4, no3 = StandardLineParser.parse('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				')
    first.should    == '2'
    second.should   == '1'
    nh4.should      == '0.048'
    no3.should      == '0.714'
  end
  it 'parses another sample line' do
    first, second, nh4, no3 = StandardLineParser.parse('14:38	264	3-1a	     236629	   11.523					    157358	   10.109				')
    first.should    == '3'
    second.should   == '1'
    nh4.should      == '11.523'
    no3.should      == '10.109'
  end
end
