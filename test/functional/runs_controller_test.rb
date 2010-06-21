require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    4.times {Factory.create :run}
    @run = Factory.create :run
  end
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create run" do
    old_count = Run.count
    file_name = '/../data/test.TXT'
    
    post :create, :run => {:sample_date => Date.today, :sample_type_id => 2}, :data => {:file => fixture_file_upload(file_name)}

    assert old_count + 1, Run.count
    assert assigns(:run)
    assert_redirected_to run_path(assigns(:run))
  end

  test "should show run" do
    get :show, :id => @run.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @run.id
    assert_response :success
  end

  test "should update run" do
    put :update, :id => @run.id
    assert assigns(:run)
    assert_redirected_to run_path(@run)
  end

  test "should destroy run" do
    old_count = Run.count
    delete :destroy, :id => @run.id
    
    assert old_count -1, Run.count
    assert_redirected_to runs_path
  end
  
  context 'creating runs' do
    should 'throw an itelligent error message when uploading a file with the wrong sample_type'
  end
end
