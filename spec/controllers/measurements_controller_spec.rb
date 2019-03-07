# frozen_string_literal: true

require 'rails_helper'

describe MeasurementsController, type: :controller do
  before(:each) do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  it 'should destroy and undestroy measurement' do
    @run = FactoryBot.build(:run_with_measurements)
    @run.save
    @measurement = FactoryBot.create(:measurement, run_id: @run.id)
    xhr :delete, :destroy, id: @measurement, sample_class: 'Sample', run_id: @run.id
    @measurement.reload
    assert @measurement.deleted
    xhr :delete, :destroy, id: @measurement, sample_class: 'Sample', run_id: @run.id
    @measurement.reload
    assert !@measurement.deleted
  end
end
