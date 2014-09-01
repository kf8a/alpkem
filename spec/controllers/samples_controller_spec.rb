require 'rails_helper'

describe SamplesController do
  before(:each) do

  end

  it "should get index" do
    get :index
    assert_response :success
    expect(assigns(:samples)).to_not be_nil
  end
end

