require 'rails_helper'

describe Parsers::StandardLineParser do
  it 'parses a soil sample lines' do
    first, second, nh4, no3 = Parsers::StandardLineParser.parse('10:38	101	2-1a	     6282	   0.048					    74108	   0.714				')
    expect(first).to  eq('2')
    expect(second).to eq('1')
    expect(nh4).to    eq('0.048')
    expect(no3).to    eq('0.714')
  end
  it 'parses another sample line' do
    first, second, nh4, no3 = Parsers::StandardLineParser.parse('14:38	264	3-1a	     236629	   11.523					    157358	   10.109				')
    expect(first).to  eq('3')
    expect(second).to eq('1')
    expect(nh4).to    eq('11.523')
    expect(no3).to    eq('10.109')
  end
end
