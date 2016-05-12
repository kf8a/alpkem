require 'rails_helper'

describe RunsController, type: :controller do
  before(:each) do
    @cn_run = FactoryGirl.build(:cn_run_with_measurements)
    @cn_run.save
    @run = FactoryGirl.build(:run_with_measurements)
    @run.save
    @measurement ||= FactoryGirl.create(:measurement, :run => @run)
    @user ||= find_or_factory(:user)
    sign_in @user

    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
  end

  it "should get new" do
    get :new
    assert_response :success
  end

  describe "POST :create with invalid sample type" do
    before(:each) do
      # file_name = Rails.root.join('test', 'data', 'new_format_soil_samples_090415.TXT')
      post :create, :run => {:sample_date => Date.today,
          :sample_type_id => 1},
          :data => {:file => fixture_file_upload('/new_format_soil_samples_090415.TXT')}
    end

    it { should render_template "new" }
  end

  describe "POST :create with no file" do
    before(:each) do
      post :create, :run => @attr, :data => nil
    end

    it { should render_template "new" }
  end

  describe "POST :create with blank file" do
    before(:each) do
      post :create, :run => @attr, :data => {:file => fixture_file_upload('/blank.txt')}
    end

    it { should render_template "new" }
  end

  describe "GET :index" do
    before(:each) do
      get :index
    end

    it { should respond_with :success }
  end

  describe "GET :cn" do
    before(:each) do
      get :cn
    end

    it { should respond_with :success }
  end

  describe "GET :show the non-CN run" do
    before(:each) do
      get :show, :id => @run.id
    end

    it { should respond_with :success }
  end

  describe "GET :show the cn run" do
    before(:each) do
      get :show, :id => @cn_run.id
    end

    it { should respond_with :success }
  end

  describe "GET :edit the non-CN run" do
    before(:each) do
      get :edit, :id => @run.id
    end

    it { should respond_with :success }
  end

  describe "PUT :update the non-CN run" do
    before(:each) do
      put :update, :id => @run.id, :run => {:sample_date => Date.yesterday}
    end

    it { should redirect_to run_path(@run) }
  end

  describe "DELETE :destroy the run" do
    before(:each) do
      delete :destroy, :id => @run.id
    end

    # it "should destroy the run" do
    #   assert_raises ActiveRecord::RecordNotFound,  Run.find(@run.id)
    # end

    it { should redirect_to runs_path }
  end

  describe "should create run" do
    before do
      file_name = Rails.root.join('test', 'data', 'new_format_soil_samples_090415.TXT')
      post :create, :run => @attr, :data => {:file => fixture_file_upload('/new_format_soil_samples_090415.TXT')}
    end

    it { should redirect_to run_path(assigns(:run)) }
  end

  it "should approve and disapprove sample" do
    sample = FactoryGirl.create(:sample)
    FactoryGirl.create(:measurement, :sample_id => sample.id, :run_id => @run.id)
    xhr :get, :approve, :id => sample, :sample_class => "Sample", :run_id => @run.id
    sample.reload
    assert sample.approved?
    xhr :get, :approve, :id => sample, :sample_class => "Sample", :run_id => @run.id
    sample.reload
    assert sample.new?
  end

  describe 'POST merge a split run' do
    before do
      file1 = fixture_file_upload('/03262012.TXT', 'text/plain')
      @file2 = fixture_file_upload('/3262012B.TXT', 'text/plain')

      post :create, :run => {:sample_date => Date.today, :sample_type_id => '2'}, 
        :data => {:file => file1}
      run = assigns(:run)
      @sample = run.samples[35]
    end

    it 'uploads the right number of measurements' do
      expect(@sample.measurements.count).to eql(6)
    end


    it 'should group the samples together' do
      post :create, :run => {:sample_date => Date.today, :sample_type_id => '2'}, 
        :data => {:file => @file2}

      expect(@sample.measurements.count).to eql(6)
    end
  end

end
