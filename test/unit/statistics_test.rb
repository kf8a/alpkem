require 'test_helper'
require 'statistics'

class MiniStatisticsTest < MiniTest::Unit::TestCase
  def test_mean
    assert_equal 0, Statistics.mean([])
    assert_equal 2, Statistics.mean([1, 2, 3])
    assert_equal 2.5, Statistics.mean([1,2,3,4])
    assert_equal 4, Statistics.mean([1,2,3,4,5,6,7])
  end

  def test_variance
    assert_equal 0, Statistics.variance([])
    assert_equal 0, Statistics.variance([1])
    assert_equal 1.25, Statistics.variance([1, 2, 3, 4])
    assert_equal 4, Statistics.variance([1,2,3,4,5,6,7])
  end

  def test_sigma
    assert_equal 0, Statistics.sigma([])
    assert_equal 0, Statistics.sigma([1])
    assert_equal 2, Statistics.sigma([1,2,3,4,5,6,7])
  end

  def test_cv
    assert_equal 0, Statistics.cv([])
    assert_equal 0, Statistics.cv([1])
    assert_equal 100, Statistics.cv([0, 0, 0])
    assert_equal 50, Statistics.cv([1,2,3,4,5,6,7])
  end
end