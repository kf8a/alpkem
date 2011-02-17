require 'spec_helper'

describe SamplesController do
  before(:each) do

  end

  it "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:samples)
  end
end

