require 'spec_helper'

describe MeasurementsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it "should destroy and undestroy measurement" do
    @run = FactoryGirl.create(:run)
    @measurement = FactoryGirl.create(:measurement, :run_id => @run.id)
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert @measurement.deleted
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert ! @measurement.deleted
  end
end
