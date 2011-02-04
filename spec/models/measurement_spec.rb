require 'spec_helper'

describe Measurement do
  before(:each) do
    @valid_measurement = find_or_factory(:measurement)
  end

  it "should validate presence of amount" do
    assert @valid_measurement.valid?
    @valid_measurement.amount = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end

  it "should validate presence of analyte" do
    assert @valid_measurement.valid?
    @valid_measurement.analyte = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end

  it "should validate presence of sample" do
    assert @valid_measurement.valid?
    @valid_measurement.sample = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end
end