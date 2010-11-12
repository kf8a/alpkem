require 'test_helper'

class MeasurementsControllerTest < ActionController::TestCase

  def setup
    Analyte.all.each {|a| a.destroy}
    CnMeasurement.all.each {|c| c.destroy}
    CnSample.all.each {|c| c.destroy}    
    Measurement.all.each {|m| m.destroy}
    Plot.all.each {|p| p.destroy}
    Replicate.all.each {|r| r.destroy}
    Run.all.each {|r| r.destroy}
    Sample.all.each {|s| s.destroy}
    Study.all.each {|s| s.destroy}
    Treatment.all.each {|t| t.destroy}
    User.all.each {|u| u.destroy}
    
    
    @user = Factory.create :user
    sign_in @user
   
  end
  
  def teardown
    Analyte.all.each {|a| a.destroy}
    CnMeasurement.all.each {|c| c.destroy}
    CnSample.all.each {|c| c.destroy}    
    Measurement.all.each {|m| m.destroy}
    Plot.all.each {|p| p.destroy}
    Replicate.all.each {|r| r.destroy}
    Run.all.each {|r| r.destroy}
    Sample.all.each {|s| s.destroy}
    Study.all.each {|s| s.destroy}
    Treatment.all.each {|t| t.destroy}
    User.all.each {|u| u.destroy}
  end
  
  test "should destroy and undestroy measurement" do
    @run = Factory.create(:run)
    @measurement = Factory.create(:measurement, :run_id => @run.id)
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert @measurement.deleted
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample", :run_id => @run.id
    @measurement.reload
    assert ! @measurement.deleted
  end
end
