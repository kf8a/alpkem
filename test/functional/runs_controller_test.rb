require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    @cn_run = Factory.create(:cn_run)
    @run = Factory.create(:run)
    measurement = Factory.create(:measurement, :run => @run)
    @user = Factory.create :user
    sign_in @user

    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  context "POST :create with invalid sample type" do
    setup do
      file_name = '/../data/new_format_soil_samples_090415.TXT'
      post :create, :run => {:sample_date => Date.today,
          :sample_type_id => 1},
          :data => {:file => fixture_file_upload(file_name)}
    end

    should render_template "new"
  end

  context "POST :create with no file" do
    setup do
      post :create, :run => @attr, :data => nil
    end

    should render_template "new"
  end

  context "POST :create with blank file" do
    setup do
      file_name = '/../data/blank.txt'
      post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}
    end

    should render_template "new"
  end

  context "GET :cn" do
    setup do
      get :cn
    end

    should respond_with :success
    should assign_to :runs
  end

  context "GET :show the cn run" do
    setup do
      get :show, :id => @cn_run.id
    end

    should respond_with :success
    should assign_to :run
  end

  context "GET :index" do
    setup do
      get :index
    end

    should respond_with :success
    should assign_to :runs
  end

  context "GET :show the non-CN run" do
    setup do
      get :show, :id => @run.id
    end

    should respond_with :success
  end

  context "GET :edit the non-CN run" do
    setup do
      get :edit, :id => @run.id
    end

    should respond_with :success
  end

  context "PUT :update the non-CN run" do
    setup do
      put :update, :id => @run.id, :run => {:sample_date => Date.yesterday}
    end

    should assign_to :run
    should redirect_to("the run's page") {run_path(@run)}
  end

  context "DELETE :destroy the run" do
    setup do
      delete :destroy, :id => @run.id
    end

    should "destroy the run" do
      assert_nil Run.find_by_id(@run.id)
    end
    should redirect_to("the runs index page") {runs_path}
  end

  test "should create run" do
    file_name = '/../data/new_format_soil_samples_090415.TXT'
    post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}

    assert assigns(:run)
    assert_redirected_to run_path(assigns(:run))
  end

  test "should approve and disapprove sample" do
    sample = Factory.create(:sample)
    Factory.create(:measurement, :sample_id => sample.id, :run_id => @run.id)
    xhr :get, :approve, :id => sample, :sample_class => "Sample", :run_id => @run.id
    sample.reload
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "Sample", :run_id => @run.id
    sample.reload
    assert ! sample.approved
  end
end
