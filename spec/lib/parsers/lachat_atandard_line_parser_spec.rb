require 'rails_helper'

describe Parsers::LachatStandardLineParser do
  describe 'parses a soil sample lines' do
    before do
      @first, @second, @nh4, @no3, @date = Parsers::LachatStandardLineParser.parse('20130604T1R1-25-c,Unknown,1,1,3,1,1,,,,10/29/2014,11:45:13 AM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.164,,mg/L,0.563,0.0534,Conc = 0.656 * Area - 0.205,48.5,36,0.164,0.164,0.164,2,Nitrate-Nitrite,0.0969,,mg N/L,0.277,0.0219,Conc = 0.464 * Area - 0.0319,47.5,34,0.0969,0.0969,0.0969')
    end
    it 'has the right date' do
      expect(@date).to   eq(Date.new(2013,6,4))
    end
    it 'has the right treatment' do
      expect(@first).to  eq('1')
    end
    it 'hast the right replicate' do
      expect(@second).to eq('1')
    end
    it 'has the right ammonium' do
      expect(@nh4).to    eq(0.164)
    end
    it 'has the right nitrate' do
      expect(@no3).to    eq(0.0969)
    end
  end

  describe 'a forest line' do
    before do
      @first, @second, @nh4, @no3, @date = Parsers::LachatStandardLineParser.parse( "20130604TCFR1-25-b,Unknown,1,1,140,1,1,,,,10/29/2014,1:24:37 PM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.324,,mg/L,0.807,0.0758,Conc = 0.656 * Area - 0.205,47.5,35,0.324,0.324,0.324,2,Nitrate-Nitrite,0.0921,,mg N/L,0.267,0.0212,Conc = 0.464 * Area - 0.0319,46,34,0.0921,0.0921,0.0921")
    end

    it 'has the correct date' do
      expect(@date).to   eq(Date.new(2013,6,4))
    end
    it 'has the correct treatment' do
      expect(@first).to  eq('CF')
    end
    it 'has the correct replicate' do
      expect(@second).to eq('1')
    end

    it 'has the correct ammonium' do
      expect(@nh4).to    eq(0.324)
    end
    it 'has the correct nitrate' do
      expect(@no3).to    eq(0.0921)
    end
  end

  describe 'a blank line' do
    before do
      @first, @second, @nh4, @no3, @date = Parsers::LachatStandardLineParser.parse("20130604Tblank-25-b,Unknown,1,1,167,1,1,,,,10/29/2014,1:43:19 PM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.00509,,mg/L,0.32,0.0317,Conc = 0.656 * Area - 0.205,48.5,36,0.00509,0.00509,0.00509,2,Nitrate-Nitrite,0.00707,,mg N/L,0.0839,0.0058,Conc = 0.464 * Area - 0.0319,47.5,35,0.00707,0.00707,0.00707")
    end

    it 'returns nil' do
      expect(@date).to be_nil
    end

  end
end
