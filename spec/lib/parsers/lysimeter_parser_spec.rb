require 'rails_helper'

describe Parsers::LysimeterParser do

  describe 'parsing lysimeter files' do
    before(:each) do
        data = [
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

    it 'should have only one sample' do
      assert_equal @samples[0].id, @samples[1].id
      assert_equal @samples[1].id, @samples[2].id
    end

    it 'should have the right nh4 amounts' do
      nh4 = Analyte.find_by_name("NH4")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => nh4.id).include?(0.046)
      sample.measurements.where(:analyte_id => nh4.id).include?(0.055)
    end

    it 'should have the right no3 amounts' do
      no3 = Analyte.find_by_name("NO3")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => no3.id).include?(-0.030)
      sample.measurements.where(:analyte_id => no3.id).include?(-0.031)
    end
  end

end
