require 'test_helper'

class AnalyteTest < ActiveSupport::TestCase
  should have_many :measurements
  should have_many :cn_measurements
end
