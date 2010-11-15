require 'test_helper'

class MeasurementsControllerTest < ActionController::TestCase

  def setup
    @user = Factory.create :user
    sign_in @user
  end
  
  test "should destroy and undestroy measurement" do
    @run = Factory.create(:run)
    @measurement = Factory.create(:measurement, :run_id => @run.id)
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert @measurement.deleted
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert ! @measurement.deleted
  end
end
