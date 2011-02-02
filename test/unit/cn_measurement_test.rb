require 'test_helper'
require 'minitest/autorun'

describe CnMeasurement do
    
  describe "a sample with a cn measurement" do
    before do
      @sample = find_or_factory(:cn_sample)
      @measurement = find_or_factory(:cn_measurement, :cn_sample_id => @sample.id)
    end

    it "should return its cn_sample when asked for sample" do
      assert @measurement.sample == @sample
    end
  end
end
