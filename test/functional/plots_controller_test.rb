require 'test_helper'

class PlotsControllerTest < ActionController::TestCase

  context "GET :index" do
    setup do
      get :index
    end

    should render_template 'index'
  end
  
  context "GET :new" do
    setup do
      
      @user = Factory.create :user
      sign_in @user

      get :new
    end

    should render_template 'new'
  end

  context "POST :create_plots" do
    setup do
      @study = Factory.create(:study, :name => "teststudy")
      post :create_plots, :study_name => @study.name
    end

    should redirect_to("the plot's show page") { plot_path(@study.id) }
  end

  context "GET :show" do
    setup do
      @study = Factory.create(:study, :name => "teststudy")
      get :show, :id => @study.id
    end

    should render_template 'show'
  end

  context "GET :edit" do
    setup do
      @study = Factory.create(:study, :name => "teststudy")
      get :edit, :id => @study.id
    end
  end

  context "PUT :update_plots" do
    setup do
      @study = Factory.create(:study, :name => "teststudy")
      put :update_plots, :id => @study.id
    end

    should redirect_to("the plot's show page") { plot_path(@study.id) }
  end

end
