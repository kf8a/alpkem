require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    #TODO make these factories work with the models as they are now
#    4.times {Factory.create :run}
#    @run = Factory.create :run

    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
    file_name = File.dirname(__FILE__) + '/../data/LTER_soil_test.TXT'
    File.open(file_name, 'r') do |f|
      @good_data = StringIO.new(f.read)
    end
    @run = Run.new(@attr)
    @run.load(@good_data)
    @run.save
    
    @cn_attr = {
      :sample_type_id => 6,
      :sample_date    => Date.today.to_s
    }
    file_name = File.dirname(__FILE__) + '/../data/DC01CFR1.csv'
    File.open(file_name, 'r') do |f|
      @cn_data = StringIO.new(f.read)
    end
    @cn_run = Run.new(@cn_attr)
    @cn_run.load(@cn_data)
    @cn_run.save

  end
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:runs)
  end
  
  test "should get cn" do
    get :cn
    assert_response :success
    assert_not_nil assigns(:runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not create run with invalid sample type" do
    assert_no_difference 'Run.count' do
      file_name = '/../data/LTER_soil_test.TXT'
      post :create, :run => {:sample_date => Date.today, :sample_type_id => 1},
                    :data => {:file => fixture_file_upload(file_name)}
    end
  end

  test "should not create run with no file" do
    assert_no_difference 'Run.count' do
      post :create, :run => @attr, :data => nil
    end
  end

  test "should not create run with blank file" do
    assert_no_difference 'Run.count' do
      file_name = '/../data/blank.txt'
      post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}
    end
  end

  test "should create run" do
    assert_difference "Run.count" do
      file_name = '/../data/LTER_soil_test.TXT'
      post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}
    end

    assert assigns(:run)
    assert_redirected_to run_path(assigns(:run))
  end
  

  test "should show run" do
    get :show, :id => @run.id
    assert_response :success
  end
  
  test "should show cn run" do
    get :show, :id => @cn_run.id
    assert_response :success
    assert assigns(:run)
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
    assert_difference "Run.count", -1 do
      delete :destroy, :id => @run.id
    end
    assert_redirected_to runs_path
  end
  
  test "should approve and disapprove sample" do
    sample = Sample.find(:first)
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    assert assigns(:sample).approved
    sample = assigns(:sample)
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    assert ! assigns(:sample).approved
  end
  
  test "should approve and disapprove cn sample" do
    sample = CnSample.find(:first)
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    assert assigns(:sample).approved
    sample = assigns(:sample)
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    assert ! assigns(:sample).approved
  end
end
