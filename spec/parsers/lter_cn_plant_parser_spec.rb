require 'rails_helper'

describe LterCnPlantParser do

  describe 'excel csv format' do
    before do
       @parser = FileParser.for(14,Date.today)
    end
    describe 'a line of data' do
      before do
        @parser.process_line('20070626,11,0706T01R2-TRIGRA,2.816,9856,Unknown,,,,1.5809,40.7759')
      end

      it "has the right date" do
        expect(@parser.sample.sample_date).to eq(Date.new(2007,06,26))
      end
      it "has the right plot" do
        expect(@parser.sample.plot.name).to eq('T1R2TRIGR')
      end
      it "has the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.5809
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 40.7759
      end
    end

    describe 'another line of data' do
      before do
        @parser.process_line('20070625,28,0706TSFR1-TRIGRB,2.639,9872,Unknown,,,,1.4945,41.8258')
      end

      it "has the right date" do
        expect(@parser.sample.sample_date).to eq(Date.civil(2007,06,25))
      end
      it "has the right plot" do
        expect(@parser.sample.plot.name).to eq('TSFR1TRIGR')
      end
      it "has the right measurement" do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 1.4945
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 41.8258
      end
    end

    describe 'a species with fractions' do
      before do 
        @parser.process_line('20030107,15,0301T05R2-POPEUR.TRNC,4.958,6868,Unk,,,,0.4622,51.5293')
      end
      it 'has the right date' do
        expect(@parser.sample.sample_date).to eq(Date.civil(2003,01,07))
      end
      it 'has the right plot' do
        expect(@parser.sample.plot.name).to eq('T5R2POPEUR.TRN')
      end
      it 'has the right measurements' do
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 0.4622
        assert_includes @parser.sample.measurements.collect {|x| x.amount}, 51.5293
      end

    end
  end

end

