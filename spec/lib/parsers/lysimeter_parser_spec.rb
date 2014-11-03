require 'rails_helper'

describe Parsers::LysimeterParser do

  describe 'parsing lysimeter files' do
    before(:each) do
        data = [
      "13:14	201	2-2-1a, 20090614	     1592	   0.046					     1776	  -0.030	LO	",
      "13:14	201	2-2-1a, 20090615	     1592	   0.046					     1776	  -0.030	LO	",
      "13:15	202	2-2-1b, 20090615	     1600	   0.046					     1718	  -0.031	LO	",
      "13:16	203	2-2-1c, 20090615	     2564	   0.055					     1709	  -0.031	LO	"
        	]

       parser = Parsers::Parser.for(1, Date.today)

       @samples = data.collect do |line|
         parser.process_line(line, Parsers::LysimeterLineParser)
         parser.sample
       end
    end

    it 'should have only two sample' do
      assert @samples[0].id != @samples[1].id
      assert_equal @samples[1].id, @samples[2].id
      assert_equal @samples[1].id, @samples[3].id
    end

    it 'should have the right number of analyses' do
      nh4 = Analyte.find_by(name: "NH4")
      sample = @samples[0]
      assert sample.measurements.where(analyte_id: nh4).size == 1

      sample = @samples[1]
      assert sample.measurements.where(analyte_id: nh4).size == 3
    end

    it "should have the right date" do
      assert @samples[0].sample_date == Date.new(2009,6,14)
      assert @samples[1].sample_date == Date.new(2009,6,15)
    end

    it 'should have the right nh4 amounts' do
      nh4 = Analyte.find_by(name: "NH4")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => nh4.id).include?(0.046)
      sample.measurements.where(:analyte_id => nh4.id).include?(0.055)
    end

    it 'should have the right no3 amounts' do
      no3 = Analyte.find_by(name: "NO3")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => no3.id).include?(-0.030)
      sample.measurements.where(:analyte_id => no3.id).include?(-0.031)
    end
  end


  describe 'parsing lachat lysimeter files' do
    before(:each) do
        data = [
"SF-2-2a 20130616,Unknown,1,1,4,1,1,,,,10/21/2014,9:25:00 AM,mcca,OM_10-21-2014_09-00-45AM.OMN,,1,Ammonia,0.0231,,mg/L,-0.114,-0.0087,Conc = 0.699 * Area + 0.103,47.5,32.5,0.0231,0.0231,0.0231,2,Nitrate-Nitrite,0.277,,mg N/L,0.548,0.0522,Conc = 0.533 * Area - 0.0148,46.5,35.0,0.277,0.277,0.277",
"SF-2-2a 20130617,Unknown,1,1,4,1,1,,,,10/21/2014,9:25:00 AM,mcca,OM_10-21-2014_09-00-45AM.OMN,,1,Ammonia,0.0231,,mg/L,-0.114,-0.0087,Conc = 0.699 * Area + 0.103,47.5,32.5,0.0231,0.0231,0.0231,2,Nitrate-Nitrite,0.277,,mg N/L,0.548,0.0522,Conc = 0.533 * Area - 0.0148,46.5,35.0,0.277,0.277,0.277",
"SF-2-2b 20130617,Unknown,1,1,5,1,1,,,,10/21/2014,9:25:39 AM,mcca,OM_10-21-2014_09-00-45AM.OMN,,1,Ammonia,0.011,,mg/L,-0.131,-0.00835,Conc = 0.699 * Area + 0.103,47.5,33.0,0.011,0.011,0.011,2,Nitrate-Nitrite,0.298,,mg N/L,0.587,0.0522,Conc = 0.533 * Area - 0.0148,46.5,34.0,0.298,0.298,0.298",
"SF-2-2c 20130617,Unknown,1,1,6,1,1,,,,10/21/2014,9:26:17 AM,mcca,OM_10-21-2014_09-00-45AM.OMN,,1,Ammonia,0.0216,,mg/L,-0.116,-0.00727,Conc = 0.699 * Area + 0.103,48.0,32.5,0.0216,0.0216,0.0216,2,Nitrate-Nitrite,0.296,,mg N/L,0.584,0.0518,Conc = 0.533 * Area - 0.0148,46.5,34.0,0.296,0.296,0.296"
        	]

       parser = Parsers::Parser.for(1, Date.today)

       @samples = data.collect do |line|
         parser.process_line(line, Parsers::LachatLysimeterLineParser)
         parser.sample
       end
    end

    it 'should have only two sample' do
      assert @samples[0].id != @samples[1].id
      assert_equal @samples[1].id, @samples[2].id
      assert_equal @samples[1].id, @samples[3].id
    end

    it "should have the right date" do
      assert @samples[0].sample_date == Date.new(2013,6,16)
      assert @samples[1].sample_date == Date.new(2013,6,17)
    end

    it 'should have the right number of analyses' do
      nh4 = Analyte.find_by(name: "NH4")
      sample = @samples[0]
      assert sample.measurements.where(analyte_id: nh4).size == 1

      sample = @samples[1]
      assert sample.measurements.where(analyte_id: nh4).size == 3
      sample = @samples[2]
      assert sample.measurements.where(analyte_id: nh4).size == 3
      sample = @samples[3]
      assert sample.measurements.where(analyte_id: nh4).size == 3
    end

    it 'should have the right nh4 amounts' do
      nh4 = Analyte.find_by(name: "NH4")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => nh4.id).include?(0.049)
      sample.measurements.where(:analyte_id => nh4.id).include?(0.054)
    end

    it 'should have the right no3 amounts' do
      no3 = Analyte.find_by(name: "NO3")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => no3.id).include?(-0.030)
      sample.measurements.where(:analyte_id => no3.id).include?(-0.031)
    end
  end



end
