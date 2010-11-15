require 'test_helper'

class PlotTest < ActiveSupport::TestCase

  should belong_to :study
  should belong_to :treatment
  should belong_to :replicate

  should validate_uniqueness_of(:name).scoped_to(:study_id)

  context "a new treatment and replicate with a plot" do
    setup do
      @treatment = Factory.create(:treatment, :name => "Treatment")
      @replicate = Factory.create(:replicate, :name => "Replicate")
      @plot = Factory.create(:plot, :treatment => @treatment, :replicate => @replicate)
    end

    should "be found by Plot.find_by_treatment_and_replicate" do
      assert_equal @plot, Plot.find_by_treatment_and_replicate("Treatment", "Replicate")
    end
  end
end
