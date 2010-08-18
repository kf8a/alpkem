require File.dirname(__FILE__) + '/../test_helper'

class RunsControllerTest < ActionController::TestCase
  
  def setup
    #TODO make these factories work with the models as they are now
#    4.times {Factory.create :run}
#    @run = Factory.create :run

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
    
    should redirect_to("the new run page") {new_run_path}
  end
  
  context "POST :create with no file" do
    setup do
      post :create, :run => @attr, :data => nil      
    end
    
    should render_template :new
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
      file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
      File.open(file_name, 'r') do |f|
        @good_data = StringIO.new(f.read)
      end
      @run = Run.new(@attr)
      @run.load(@good_data)
      @run.save    
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
      should "get graphs from googlecharts" do
        assert_select "img", {:minimum => 20} #Don't make this too precise
      end
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
#    sample = Sample.find(:first)
    sample = Factory.create(:sample)
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    assert assigns(:sample).approved
    sample = assigns(:sample)
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "Sample"
    assert ! assigns(:sample).approved
  end
  
  test "should approve and disapprove cn sample" do
#    sample = CnSample.find(:first)
    sample = Factory.create(:cn_sample)
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    assert assigns(:sample).approved
    sample = assigns(:sample)
    assert sample.approved
    xhr :get, :approve, :id => sample, :sample_class => "CnSample"
    assert ! assigns(:sample).approved
  end
end
