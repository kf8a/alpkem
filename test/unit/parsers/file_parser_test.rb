require File.expand_path('../../../test_helper',__FILE__) 

class FileParserTest < ActiveSupport::TestCase
  
    def setup  
      @parser = FileParser.for(9, Date.today)
    end
    
    def test_that_the_same_sample_is_returned
      @parser.find_plot('T1R1')
      @parser.create_sample
      sample = @parser.sample
      @parser.find_sample
      assert_equal sample, @parser.sample
      @parser.find_or_create_sample
      assert_equal sample, @parser.sample
    end
 
end

