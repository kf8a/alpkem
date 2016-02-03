require 'rails_helper'

describe Parsers::NO3StandardLineParser do
  it 'parses an NO3 only line' do
    first, second, nh4, no3 = Parsers::NO3StandardLineParser.parse('09:54	106	4-4c	     9541	   0.104				')
    expect(first).to eql('4')
    expect(second).to eql('4')
    expect(no3).to eql('0.104')
    expect(nh4).to be_nil
  end
end
