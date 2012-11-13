require 'spec_helper'

describe StandardLineParser do
  it 'parses soil sample lines' do
    first, second, nh4, no3 = StandardLineParser.parse('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				')
    first.should    == '2'
    second.should   == '1'
    nh4.should      == '0.048'
    no3.should      == '0.714'
  end
end
