require 'rails_helper'

describe SampleType, type: :model do
  it { should have_many :samples }
  it { should have_many :runs }

  it 'should get the right name for each sample_type_id' do
    assert_equal 'Lysimeter', SampleType.find(1).name
    assert_equal 'Soil Sample', SampleType.find(2).name
    assert_equal 'GLBRC Soil Sample', SampleType.find(3).name
    assert_equal 'GLBRC Deep Core Nitrogen', SampleType.find(4).name
    assert_equal 'GLBRC Resin Strips', SampleType.find(5).name
    assert_equal 'CN Soil Sample', SampleType.find(6).name
    assert_equal 'CN Deep Core', SampleType.find(7).name
    assert_equal 'GLBRC Soil Sample (New)', SampleType.find(8).name
    assert_equal 'GLBRC CN', SampleType.find(9).name
    assert_equal 'Lysimeter NO3', SampleType.find(10).name
    assert_equal 'Lysimeter NH4', SampleType.find(11).name
  end

end
