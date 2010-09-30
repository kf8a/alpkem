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
    @measurement = Factory.create(:measurement)
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample"
    @measurement.reload
    assert @measurement.deleted
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample"
    @measurement.reload
    assert ! @measurement.deleted
  end
  
  test "should destroy and undestroy cn measurement" do
    @cnmeasurement  = Factory.create(:cn_measurement)
    xhr :delete, :destroy, :id => @cnmeasurement, :sample_class => "CnSample"
    @cnmeasurement.reload
    assert @cnmeasurement.deleted
    xhr :delete, :destroy, :id => @cnmeasurement, :sample_class => "CnSample"
    @cnmeasurement.reload
    assert ! @cnmeasurement.deleted
  end

end
