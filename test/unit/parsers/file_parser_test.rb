require File.expand_path('../../../test_helper',__FILE__) 

class FileParserTest < ActiveSupport::TestCase
  
    def setup  
      @parser = FileParser.for(9, Date.today)
    end
    
    def test_that_the_same_sample_is_returned
      plot = @parser.find_plot('T1R1')
      sample = @parser.create_sample(Date.today)
      assert_equal sample, @parser.find_sample(Date.today)
      assert_equal sample, @parser.find_or_create_sample(Date.today)
    end
    
    def test_parsing_of_lysimeter_samples
      data = [
    "   13:14	201	7-2-1a, 20090615	     1592	   0.046					     1776	  -0.030	LO	",		
    "  	13:15	202	7-2-1b, 20090615	     1600	   0.046					     1718	  -0.031	LO	",
    "  	13:16	203	7-2-1c, 20090615	     2564	   0.055					     1709	  -0.031	LO	",		
      	]
      
      sample = @parser.parse(line)
    end
end

