require File.dirname(__FILE__) + '/../test_helper'

class MeasurementsControllerTest < ActionController::TestCase

  def setup
    @measurement = Factory.create :measurement
    @measurement.save
  end
  
  test "should destroy measurement" do
#    delete :destroy, :id => @measurement
    #TODO figure out how to test the delete 
    #assert @measurement.deleted == true
  end
end
