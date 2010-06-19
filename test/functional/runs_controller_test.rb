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
    
    post :create, :run => {:sample_date => Date.today, :sample_type_id => 1}, :data => {:file => fixture_file_upload(file_name, "txt")}

    assert old_count + 1, Run.count
    
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert_valid(sample)
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    assert_equal 0.053056531, sample.measurements_by_analyte(no3)[0].amount
    assert_equal 0.295276523, sample.measurements_by_analyte(nh4)[0].amount
    
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
    #Right now this test just tests whether the update action works at all, not whether it actually updates anything.
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
end
