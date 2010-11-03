require 'test_helper'
require 'rails/performance_test_help'

class RunsPerformanceTest < ActionDispatch::PerformanceTest
  def test_runs_page
    get '/runs'
  end
end
