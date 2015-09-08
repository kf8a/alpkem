require 'rails_helper'

#TODO the generic parser should be merged into the standard line parser
#this is the same as the StandardLineParser
describe Parsers::LachatGenericLineParser do
  describe 'parses a glbrc soil sample lines' do
    before do
      @first, @second, @depth, @nh4, @no3, @date = Parsers::LachatGenericLineParser.parse('20140728G10R2-25-a,Unknown,1,1,4,1,1,,,,12/15/2014,12:03:50 PM,mcca,OM_12-15-2014_11-44-19AM.OMN,,1,Ammonia,0.184,,mg/L,0.525,0.0484,Conc = 0.749 * Area - 0.209,47.5,35,0.184,0.184,0.184,2,Nitrate-Nitrite,0.169,,mg N/L,0.394,0.0332,Conc = 0.494 * Area - 0.0253,46,34,0.169,0.169,0.169')
    end
    it 'has the right date' do
      expect(@date).to   eq(Date.new(2014,7,28))
    end
    it 'has the right treatment' do
      expect(@first).to  eq('10')
    end
    it 'has the right replicate' do
      expect(@second).to eq('2')
    end
    it 'has the right depth' do
      expect(@depth).to eq('25')
    end
    it 'has the right ammonium' do
      expect(@nh4).to    eq(0.184)
    end
    it 'has the right nitrate' do
      expect(@no3).to    eq(0.169)
    end
  end

end
