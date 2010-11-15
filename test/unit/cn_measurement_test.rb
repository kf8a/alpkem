require 'test_helper'
require 'minitest/autorun'

describe CnMeasurement do
    
  describe "a sample with a cn measurement" do
    before do
      @sample = Factory.create(:cn_sample)
      @measurement = Factory.create(:cn_measurement, :cn_sample => @sample)
    end

    it "should return its cn_sample when asked for sample" do
      assert @measurement.sample == @sample
    end
  end
end
