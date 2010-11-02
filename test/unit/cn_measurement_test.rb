require 'test_helper'

class CnMeasurementTest < ActiveSupport::TestCase

  context "a sample with a cn measurement" do
    setup do
      @sample = Factory.create(:cn_sample)
      @measurement = Factory.create(:cn_measurement, :cn_sample => @sample)
    end

    should "return its cn_sample when asked for sample" do
      assert @measurement.sample == @sample
    end
  end
end
