require 'test_helper'

class RoutesTest < ActionController::TestCase

  should "take me to the right page" do
    assert_generates "/plots", { :controller => "plots", :action => "index" }
    assert_generates "/plots/1", { :controller => "plots", :action => "show", :id => "1" }
  end
  
end
