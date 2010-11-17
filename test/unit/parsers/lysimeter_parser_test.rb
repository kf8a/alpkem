require File.expand_path('../../../test_helper',__FILE__) 

class LysimeterParserTest < ActiveSupport::TestCase
  context 'parsing lysimeter files' do
    setup do 
        data = [
      "13:14	201	2-2-1a, 20090615	     1592	   0.046					     1776	  -0.030	LO	",		
      "13:15	202	2-2-1b, 20090615	     1600	   0.046					     1718	  -0.031	LO	",
      "13:16	203	2-2-1c, 20090615	     2564	   0.055					     1709	  -0.031	LO	"	
        	]
        
       parser = FileParser.for(1, Date.today)
       
       @samples = data.collect do |line|
         parser.process_line(line)
         parser.sample
       end
    end
    
    should 'have the only one sample' do
      assert_equal @samples[0].id, @samples[1].id
      assert_equal @samples[1].id, @samples[2].id
    end
    
    should 'have the right nh4 amounts' do
      nh4 = Analyte.find_by_name("NH4")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => nh4.id).include?(0.046)
      sample.measurements.where(:analyte_id => nh4.id).include?(0.055)
    end
    
    should 'have the right no3 amounts' do
      no3 = Analyte.find_by_name("NO3")
      sample = @samples[0]
      sample.measurements.where(:analyte_id => no3.id).include?(-0.030)
      sample.measurements.where(:analyte_id => no3.id).include?(-0.031)
    end
  end

end