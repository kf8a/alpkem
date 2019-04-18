require 'rails_helper'

# TODO the generic parser should be merged into the standard line parser
# this is the same as the StandardLineParser
describe Parsers::LachatGenericLineParser do
  describe 'parses a glbrc soil sample lines' do
    before do
      @date, @plot, @depth, @nh4, @no3 = Parsers::LachatGenericLineParser.parse('20140728G10R2-25-a,Unknown,1,1,4,1,1,,,,12/15/2014,12:03:50 PM,mcca,OM_12-15-2014_11-44-19AM.OMN,,1,Ammonia,0.184,,mg/L,0.525,0.0484,Conc = 0.749 * Area - 0.209,47.5,35,0.184,0.184,0.184,2,Nitrate-Nitrite,0.169,,mg N/L,0.394,0.0332,Conc = 0.494 * Area - 0.0253,46,34,0.169,0.169,0.169')
    end
    it 'has the right date' do
      expect(@date).to   eq(Date.new(2014, 7, 28))
    end
    it 'has the right plot' do
      expect(@plot).to  eq('G10R2')
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

  describe 'a line of scaleup data' do
    before do
      @date, @plot, @depth, @nh4, @no3 = Parsers::LachatGenericLineParser.parse('20141203M4S02-25-a,Unknown,1,1,184,1,1,,,,12/24/2014,11:58:13 AM,mcca,OM_12-24-2014_09-33-29AM.OMN,,1,Ammonia,0.456,,mg/L,0.958,0.088,Conc = 0.743 * Area - 0.255,47.5,34,0.456,0.456,0.456,2,Nitrate-Nitrite,0.0899,,mg N/L,0.186,0.0158,Conc = 0.533 * Area - 9.39e-3,48,33.5,0.0899,0.0899,0.0899')
    end

    it 'has the right date' do
      expect(@date).to   eq(Date.new(2014, 12, 3))
    end
    it 'has the right plot' do
      expect(@plot).to  eq('M4S02')
    end
    it 'has the right depth' do
      expect(@depth).to eq('25')
    end
  end

  describe 'a microplot data line' do
    before do
      test_string = '20131007G3R5micro-25-a,Unknown,1,1,184,1,1,,,,12/24/2014,11:58:13 AM,mcca,OM_12-24-2014_09-33-29AM.OMN,,1,Ammonia,0.456,,mg/L,0.958,0.088,Conc = 0.743 * Area - 0.255,47.5,34,0.456,0.456,0.456,2,Nitrate-Nitrite,0.0899,,mg N/L,0.186,0.0158,Conc = 0.533 * Area - 9.39e-3,48,33.5,0.0899,0.0899,0.0899'
      @date, @plot, @depth, @nh4, @no3 = Parsers::LachatGenericLineParser.parse(test_string)
    end

    it 'has the right date' do
      expect(@date).to   eq(Date.new(2013, 10, 7))
    end
    it 'has the right plot' do
      expect(@plot).to  eq('G3R5micro')
    end
    it 'has the right depth' do
      expect(@depth).to eq('25')
    end
  end
end
