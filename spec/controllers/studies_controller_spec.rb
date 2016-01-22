require 'rails_helper'

describe StudiesController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  describe "GET :index" do
    before(:each) do
      get :index
    end

    it "should render index" do
      should render_template 'index'
    end
  end

  describe "GET :new" do
    before(:each) do
      @user = FactoryGirl.create :user
      sign_in @user

      get :new
    end

    it "should render new" do
      should render_template 'new'
    end
  end

  describe "POST :create_plots" do
    before(:each) do
      @study = find_or_factory :study, name: "teststudy"
      post :create, :study_name => @study.name
    end

    it "should redirect to the study show page" do
      should redirect_to study_path(@study.id)
    end
  end

  describe "GET :show" do
    before(:each) do
      @study = find_or_factory :study, name: "teststudy"
      get :show, :id => @study.id
    end

    it "should render show" do
      should render_template 'show'
    end
  end

  describe "GET :edit" do
    before(:each) do
      @study = find_or_factory :study, name: "teststudy"
      get :edit, :id => @study.id
    end

    it "should render edit" do
      should render_template 'edit'
    end
  end

  describe "PUT :update_plots" do
    describe "with a study with no current replicates" do
      before(:each) do
        @study = find_or_factory :study, name: "teststudy"
        put :update, :id => @study.id
      end

      it "should redirect to the study show page" do
        should redirect_to study_path(@study.id)
      end

      it "should set the flash" do
        should set_flash.to("There are no replicates to update.")
      end
    end

    describe "with a study with replicates already" do
      before(:each) do
        @study = find_or_factory :study, name: "teststudy"
        @study.create_plots(2, 2, "te")
        put :update, :id => @study.id, :number_of_replicates => 3, :number_of_treatments => 3
      end

      it "should redirect to the study show page" do
        should redirect_to study_path(@study.id)
      end

      it "should not set the flash" do
        should_not set_flash
      end

      it "should create additional replicates, treatments, and plots as requested" do
        @study.reload
        assert @study.replicates.count == 3
        assert @study.treatments.count == 3
        assert @study.plots.count      == 9
      end
    end
  end

end

