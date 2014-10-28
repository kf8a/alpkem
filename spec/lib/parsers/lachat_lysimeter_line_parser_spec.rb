require 'rails_helper'

describe Parsers::LachatLysimeterLineParser do
  it 'parses a sample line' do
    date, plot, nh4, no3 = Parsers::LachatLysimeterLineParser.parse('7-3-1a 20130723,Unknown,1,1,7,1,1,,,,10/23/2014,10:29:02 AM,mcca,OM_10-23-2014_10-03-22AM.OMN,,1,Ammonia,0.0273,,mg/L,-0.0546,-0.00438,Conc = 0.695 * Area + 0.0652,46.5,35.5,0.0273,0.0273,0.0273,2,Nitrate-Nitrite,0.0496,,mg N/L,0.123,0.0101,Conc = 0.522 * Area - 0.0144,46.5,34.0,0.0496,0.0496,0.0496')
    expect(date).to eql(Date.new(2013,7,23))
    expect(plot).to eql('7-3-1')
    expect(nh4).to eql(0.0273)
    expect(no3).to eql(0.0496)
  end
end
