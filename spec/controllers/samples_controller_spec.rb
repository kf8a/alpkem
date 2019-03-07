# frozen_string_literal: true

require 'rails_helper'

describe SamplesController, type: :controller do
  before do
    @sample = FactoryBot.create :sample
  end

  it 'should get index' do
    get :index
    assert_response :success
    expect(assigns(:samples)).to_not be_nil
  end

  it 'toggles measurements' do
  end

  it 'searches' do
    get :search, params: { q: 'test' }
    assert_response :success
  end
end
