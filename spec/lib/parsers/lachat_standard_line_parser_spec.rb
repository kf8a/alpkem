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
      expect(@first).to  eq('T1')
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
      expect(@first).to  eq('TCF')
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

  describe 'a wrong line' do

    it 'raises an error' do
      expect{Parsers::LachatStandardLineParser.parse("something,Unknown,1,1,167,1,1,,,,10/29/2014,1:43:19 PM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.00509,,mg/L,0.32,0.0317,Conc = 0.656 * Area - 0.205,48.5,36,0.00509,0.00509,0.00509,2,Nitrate-Nitrite,0.00707,,mg N/L,0.0839,0.0058,Conc = 0.464 * Area - 0.0319,47.5,35,0.00707,0.00707,0.00707")}.to raise_error(RuntimeError)
    end
  end

  describe 'another lter line' do
    before do
      @first, @second, @nh4, @no3, @date, @modifier = Parsers::LachatStandardLineParser.parse("20130604T1R2-25-c,Unknown,1,1,6,1,1,,,,10/29/2014,11:51:46 AM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.147,,mg/L,0.537,0.0523,Conc = 0.656 * Area - 0.205,49,35,0.147,0.147,0.147,2,Nitrate-Nitrite,0.0716,,mg N/L,0.223,0.0177,Conc = 0.464 * Area - 0.0319,46.5,34,0.0716,0.0716,0.0716")
    end
    it 'has the right treatment' do
      expect(@first).to  eq('T1')
    end
    it 'hast the right replicate' do
      expect(@second).to eq('2')
    end
    it 'hast the right replicate' do
      expect(@date).to eq Date.new(2013,6,4)
    end

    it 'has the right modifier' do
      expect(@modifier).to eq '25'
    end
  end

  describe 'a glbrc line' do
    before do
      @first, @second, @nh4, @no3, @date = Parsers::LachatStandardLineParser.parse('20130604G10R2-25-c,Unknown,1,1,3,1,1,,,,10/29/2014,11:45:13 AM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.164,,mg/L,0.563,0.0534,Conc = 0.656 * Area - 0.205,48.5,36,0.164,0.164,0.164,2,Nitrate-Nitrite,0.0969,,mg N/L,0.277,0.0219,Conc = 0.464 * Area - 0.0319,47.5,34,0.0969,0.0969,0.0969')
    end
    it 'has the right treatment' do
      expect(@first).to  eq('G10')
    end
    it 'hast the right replicate' do
      expect(@second).to eq('2')
    end
  end

  describe 'a swithcgrass line' do
    before do
      @first, @second, @nh4, @no3, @date, @modifier, @site = Parsers::LachatStandardLineParser.parse('ARL-20150729-SWF1H1R5C-15,Unknown,1,1,15,1,1,,,,1/27/2016,10:13:34 AM,mcca,OM_1-27-2016_09-43-06AM.OMN,,1,Ammonia,0.376,,mg/L,0.841,0.0791,Conc = 0.729 * Area - 0.237,47.0,33.0,0.376,0.376,0.376,2,Nitrate-Nitrite,0.0836,,mg N/L,0.277,0.0202,Conc = 0.443 * Area - 0.0391,46.5,33.5,0.0836,0.0836,0.0836')
    end

    it "has the right site" do
      expect(@site).to eq 'ARL'
    end

    it 'has the right treatment' do
      expect(@first).to  eq('SWF1H1')
    end
    it 'hast the right replicate' do
      expect(@second).to eq('5')
    end
  end

  describe 'a blank switchgrass line' do
    before do
      @first, @second, @nh4, @no3, @date, @modifier, @site = Parsers::LachatStandardLineParser.parse('ARL-20150827-BLKA-15,Unknown,1,1,133,1,1,,,,1/27/2016,11:40:54 AM,mcca,OM_1-27-2016_09-43-06AM.OMN,,1,Ammonia,-0.0019,,mg/L,0.322,0.0317,Conc = 0.729 * Area - 0.237,49.5,34.0,-0.0019,-0.0019,-0.0019,2,Nitrate-Nitrite,-0.0112,,mg N/L,0.063,0.00402,Conc = 0.443 * Area - 0.0391,49.5,37.5,-0.0112,-0.0112,-0.0112')
    end

    it "returns nil " do
      expect(@site).to be_nil
    end

  end
end
