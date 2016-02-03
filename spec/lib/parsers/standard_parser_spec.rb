require 'rails_helper'

describe Parsers::StandardParser do

  describe 'a line of lachat data' do
    before do
      @parser = Parsers::Parser.for(2,Date.today)
      @parser.process_line("20130604T1R2-25-c,Unknown,1,1,6,1,1,,,,10/29/2014,11:51:46 AM,mcca,OM_10-29-2014_11-26-19AM.OMN,,1,Ammonia,0.147,,mg/L,0.537,0.0523,Conc = 0.656 * Area - 0.205,49,35,0.147,0.147,0.147,2,Nitrate-Nitrite,0.0716,,mg N/L,0.223,0.0177,Conc = 0.464 * Area - 0.0319,46.5,34,0.0716,0.0716,0.0716", Parsers::LachatStandardLineParser)
    end

    it 'parses' do
      expect(@parser.sample).to_not be_nil
    end

    it 'has the right date' do
      expect(@parser.sample.sample_date).to eq(Date.new(2013,6,4))
    end

    it "should have the right plot" do
      expect(@parser.sample.plot.name).to eql('T1R2')
    end
    it "should have the right measurement" do
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.147
      assert_includes @parser.measurements.collect {|x| x.amount}, 0.0716
    end
  end


end
