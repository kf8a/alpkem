require 'rails_helper'

describe SamplesController do
  before do
    @sample = FactoryGirl.create :sample
  end

  it "should get index" do
    get :index
    assert_response :success
    expect(assigns(:samples)).to_not be_nil
  end

  it 'toggles measurements' do
  end

  it 'searches' do
    get :search, q: 'test'
    assert_response :success
  end
end

