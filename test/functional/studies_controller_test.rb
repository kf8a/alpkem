require 'test_helper'

class StudiesControllerTest < ActionController::TestCase

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

    should redirect_to("the study's show page") { study_path(@study.id) }
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
    context "with a study with no current replicates" do
      setup do
        @study = Factory.create(:study, :name => "teststudy")
        put :update_plots, :id => @study.id
      end

      should redirect_to("the study's show page") { study_path(@study.id) }
      should set_the_flash.to("There are no replicates to update.")
    end

    context "with a study with replicates already" do
      setup do
        @study = Factory.create(:study, :name => "teststudy")
        @study.create_plots(2, 2, "te")
        put :update_plots, :id => @study.id, :number_of_replicates => 3, :number_of_treatments => 3
      end

      should redirect_to("the study's show page") {study_path(@study.id)}
      should_not set_the_flash
      should "create additional replicates, treatments, and plots as requested" do
        @study.reload
        assert @study.replicates.count == 3
        assert @study.treatments.count == 3
        assert @study.plots.count      == 9
      end
    end
  end

end
