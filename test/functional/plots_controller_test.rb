require 'test_helper'

class PlotsControllerTest < ActionController::TestCase

  context "GET :new" do
    setup do
      
      @user = Factory.create :user
      sign_in @user

      get :new
    end

    should render_template 'new'
  end


end
