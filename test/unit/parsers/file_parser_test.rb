require File.expand_path('../../../test_helper',__FILE__) 

class FileParserTest < ActiveSupport::TestCase
  
    def setup  
      @parser = FileParser.for(9, Date.today)
    end
    
    def test_that_the_same_sample_is_returned
      plot = @parser.find_plot('T1R1')
      sample = @parser.create_sample
      assert_equal sample, @parser.find_sample(Date.today)
      assert_equal sample, @parser.find_or_create_sample(Date.today)
    end
 
end

