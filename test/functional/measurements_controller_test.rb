require File.dirname(__FILE__) + '/../test_helper'

class MeasurementsControllerTest < ActionController::TestCase

  def setup
#    @attr = {
#      :sample_type_id => 2,
#      :sample_date    => Date.today.to_s
#    }
#    file_name = File.dirname(__FILE__) + '/../data/LTER_soil_test.TXT'
#    File.open(file_name, 'r') do |f|
#      @good_data = StringIO.new(f.read)
#    end
#    @run = Run.new(@attr)
#    @run.load(@good_data)
#    @run.save
    
    @cn_attr = {
      :sample_type_id => 6,
      :sample_date    => Date.today.to_s
    }
    file_name = File.dirname(__FILE__) + '/../data/DC01CFR1.csv'
    File.open(file_name, 'r') do |f|
      @cn_data = StringIO.new(f.read)
    end
    @cn_run = Run.new(@cn_attr)
    @cn_run.load(@cn_data)
    @cn_run.save

#    @measurement = Factory.create :measurement
#    @measurement.save
#    @cnmeasurement = Factory.create :cn_measurement
#    @cnmeasurement.save
  end
  
  test "should destroy and undestroy measurement" do
#    @run = Factory.create :run
#    assert @run.valid?
    @measurement = Factory.create :measurement
    assert @measurement.valid?
    @measurement = Measurement.find(:first)
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample"
    assert assigns(:m).deleted
    @measurement = assigns(:m)
    assert @measurement.deleted
    xhr :delete, :destroy, :id => @measurement, :sample_class => "Sample"
    assert ! assigns(:m).deleted
  end
  
  test "should destroy and undestroy cn measurement" do
    @cnmeasurement = CnMeasurement.find(:first)
    xhr :delete, :destroy, :id => @cnmeasurement, :sample_class => "CnSample"
    assert assigns(:m).deleted
    @cnmeasurement = assigns(:m)
    assert @cnmeasurement.deleted
    xhr :delete, :destroy, :id => @cnmeasurement, :sample_class => "CnSample"
    assert ! assigns(:m).deleted
  end

end
