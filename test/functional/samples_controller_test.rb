require File.dirname(__FILE__) + '/../test_helper'

class SamplesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:samples)
  end

end
