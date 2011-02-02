require 'test_helper'
require 'minitest/autorun'

describe Measurement do
  before do
    @valid_measurement = find_or_factory(:measurement)
  end

  it "should validate presence of amount" do
    assert @valid_measurement.valid?
    @valid_measurement.amount = nil
    refute @valid_measurement.valid?
    refute @valid_measurement.save
  end

  it "should validate presence of analyte" do
    assert @valid_measurement.valid?
    @valid_measurement.analyte = nil
    refute @valid_measurement.valid?
    refute @valid_measurement.save
  end

  it "should validate presence of sample" do
    assert @valid_measurement.valid?
    @valid_measurement.sample = nil
    refute @valid_measurement.valid?
    refute @valid_measurement.save
  end
end