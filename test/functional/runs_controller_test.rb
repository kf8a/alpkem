require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    4.times {Factory.create :run}
    @run = Factory.create :run
    @cnrun = Factory.create :cn_run

    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
  end
  
  def teardown
    Analyte.all.each {|a| a.destroy}
    CnMeasurement.all.each {|c| c.destroy}
    CnSample.all.each {|c| c.destroy}    
    Measurement.all.each {|m| m.destroy}
    Plot.all.each {|p| p.destroy}
    Replicate.all.each {|r| r.destroy}
    Run.all.each {|r| r.destroy}
    Sample.all.each {|s| s.destroy}
    Study.all.each {|s| s.destroy}
    Treatment.all.each {|t| t.destroy}
    User.all.each {|u| u.destroy}
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
    
    should redirect_to("the new run page") {new_run_path}
  end
  
  context "POST :create with no file" do
    setup do
      post :create, :run => @attr, :data => nil      
    end
    
    should redirect_to("the new run page") {new_run_path}
  end

  context "POST :create with blank file" do
    setup do
      file_name = '/../data/blank.txt'
      post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}
    end
    
    should redirect_to("new run page") {new_run_path}
  end

  test "should create run" do
    file_name = '/../data/new_format_soil_samples_090415.TXT'
    post :create, :run => @attr, :data => {:file => fixture_file_upload(file_name)}

    assert assigns(:run)
    assert_redirected_to run_path(assigns(:run))
  end
  
  context "A cn_run" do
    setup do
      @cn_run = Factory.create(:cn_run)
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
  end
  
  context "a non-CN run" do
    setup do
      @run = Factory.create(:run)
    end
    
    context "GET :index" do
      setup do
        get :index
      end
      
      should respond_with :success
      should assign_to :runs
    end
  
    context "GET :show the run" do
      setup do
        get :show, :id => @run.id
      end
      
      should respond_with :success
    end
    
    context "GET :edit the run" do
      setup do
        get :edit, :id => @run.id
      end
      
      should respond_with :success
    end
    
    context "PUT :update the run" do
      setup do
        put :update, :id => @run.id
      end
      
      should assign_to :run
      should redirect_to("the run's page") {run_path(@run)}
    end
    
    context "DELETE :destroy the run" do
      setup do
        delete :destroy, :id => @run.id
      end
      
      should_destroy :run
      should redirect_to("the runs index page") {runs_path}
    end
  end

  test "should approve and disapprove sample" do
    sample = Factory.create(:sample)
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    sample.reload
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    sample.reload
    assert ! sample.approved
  end
  
  test "should approve and disapprove cn sample" do
    sample = Factory.create(:cn_sample)
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    sample.reload
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    sample.reload
    assert ! sample.approved
  end
end
