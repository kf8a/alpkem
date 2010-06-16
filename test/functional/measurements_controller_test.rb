require 'test_helper'

class MeasurementsControllerTest < ActionController::TestCase

  test "should destroy measurement" do
    assert_difference('Measurement.count', -1) do
      delete :destroy, :id => measurements(:one).id
    end

    assert_redirected_to measurements_path
  end
end
