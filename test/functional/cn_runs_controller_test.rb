require 'test_helper'

class CnRunsControllerTest < ActionController::TestCase

  def setup
    get :new
  end
  
  test "should get new" do
    assert_response :success
  end
  
  test "should create initial cn_run object" do
    assert_not_nil assigns(:cn_run)
  end
  
end
