require File.dirname(__FILE__) + '/../test_helper'

class SampleTest < ActiveSupport::TestCase

  should validate_presence_of :plot
end
