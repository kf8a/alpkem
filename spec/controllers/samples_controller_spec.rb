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
    pending 
  end

  it 'allows rejections' do
    @sample.approve!
    xhr :post, :reject, :id => @sample
    @sample.reload
    expect(@sample).to be_rejected
  end

  it 'allows approval' do
    @sample.approve!
    @sample.reject!
    xhr :get, :approve, :id => @sample
    @sample.reload
    expect(@sample).to be_approved
  end

  it 'searches' do
    get :search, q: 'test'
    assert_response :success
  end
end

