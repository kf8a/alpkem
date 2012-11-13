require 'spec_helper'

describe NO3LineParser do
  it 'parses an NO3 only line' do
    first, second, nh4, no3 = NO3LineParser.parse('09:54	106	4-4c	     9541	   0.104				')
    first.should    == '4'
    second.should   == '4'
    no3.should      == '0.104'
    nh4.should be_nil
  end
end
