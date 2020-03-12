# frozen_string_literal: true

require 'rails_helper'

describe Measurement do
  before(:each) do
    run = FactoryBot.build :run
    @valid_measurement = FactoryBot.create(:measurement, run: run)
  end

  it 'should validate presence of amount' do
    assert @valid_measurement.valid?
    @valid_measurement.amount = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end

  it 'should validate presence of analyte' do
    assert @valid_measurement.valid?
    @valid_measurement.analyte = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end

  it 'should validate presence of sample' do
    assert @valid_measurement.valid?
    @valid_measurement.sample = nil
    assert !@valid_measurement.valid?
    assert !@valid_measurement.save
  end
end
