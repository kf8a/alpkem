require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase

  should belong_to :analyte
  should belong_to :sample
  should belong_to :run

  should validate_presence_of :amount
  should validate_presence_of :analyte
  should validate_presence_of :sample

end
