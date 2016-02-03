require 'rails_helper'

describe Parsers::NH4StandardLineParser do
  it 'parses an NH4 only line' do
    first, second, nh4, no3 = Parsers::NH4StandardLineParser.parse('09:54	106	4-4c	     9541	   0.104				')
    expect(first).to eql('4')
    expect(second).to eql('4')
    expect(no3).to be_nil
    expect(nh4).to eql('0.104')
  end
end
