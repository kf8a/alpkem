require File.dirname(__FILE__) + '/../../app/models/parsers/no3_standard_line_parser.rb'

describe NO3StandardLineParser do
  it 'parses an NO3 only line' do
    first, second, nh4, no3 = NO3StandardLineParser.parse('09:54	106	4-4c	     9541	   0.104				')
    expect(first).to eql('4')
    expect(second).to eql('4')
    expect(no3).to eql('0.104')
    expect(nh4).to be_nil
  end
end
