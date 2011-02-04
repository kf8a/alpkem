require 'spec_helper'
require 'statistics'

describe Statistics do
  it "should_test_mean" do
    assert_equal 0, Statistics.mean([])
    assert_equal 2, Statistics.mean([1, 2, 3])
    assert_equal 2.5, Statistics.mean([1,2,3,4])
    assert_equal 4, Statistics.mean([1,2,3,4,5,6,7])
  end

  it "should_test_variance" do
    assert_equal 0, Statistics.variance([])
    assert_equal 0, Statistics.variance([1])
    assert_equal 1.25, Statistics.variance([1, 2, 3, 4])
    assert_equal 4, Statistics.variance([1,2,3,4,5,6,7])
  end

  it "should_test_sigma" do
    assert_equal 0, Statistics.sigma([])
    assert_equal 0, Statistics.sigma([1])
    assert_equal 2, Statistics.sigma([1,2,3,4,5,6,7])
  end

  it "should_test_cv" do
    assert_equal 0, Statistics.cv([])
    assert_equal 0, Statistics.cv([1])
    assert_equal 100, Statistics.cv([0, 0, 0])
    assert_equal 50, Statistics.cv([1,2,3,4,5,6,7])
  end
end