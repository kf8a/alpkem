require 'test_helper'

class PlotsControllerTest < ActionController::TestCase

  context "GET :new" do
    setup do
      get :new
    end

    should render_template 'new'
  end


end
