require 'spec_helper'

describe Parsers::LTERCNPlantParser do

  describe 'excel csv format' do
    before do
       @parser = Parsers::FileParser.for(14,Date.today)
    end
    describe 'a line of data' do
      before do
        @parser.process_line('20070626,11,0706T01R2TRIGRA,2.816,9856,Unknown,,,,1.5809,40.7759')
      end

      it "has the right date" do
        @parser.sample.sample_date.should == Date.new(2007,06,26)
      end
      it "has the right plot" do
        @parser.sample.plot.name.should =='T1R2TRIGR' 
      end
      it "has the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.5809
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 40.7759
      end
    end

    describe 'another line of data' do
      before do
        @parser.process_line('20070625,28,0706TSFR1TRIGRB,2.639,9872,Unknown,,,,1.4945,41.8258')
      end

      it "has the right date" do
        @parser.sample.sample_date.should == Date.civil(2007,06,25)
      end
      it "has the right plot" do
        @parser.sample.plot.name.should == 'TSFR1TRIGR'
      end
      it "has the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.4945
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 41.8258
      end
    end

    describe 'a species with fractions' do
      before do 
        @parser.process_line('20030107,15,0301T05R2POPEUR.TRNC,4.958,6868,Unk,,,,0.4622,51.5293')
      end
      it 'has the right date' do
        @parser.sample.sample_date.should == Date.civil(2003,01,07)
      end
      it 'has the right plot' do
        @parser.sample.plot.name.should == 'T5R2POPEUR.TRN'
      end
      it 'has the right measurements' do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.4622
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 51.5293
      end

    end
  end

end

