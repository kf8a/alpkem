require 'spec_helper'

describe Plot do
  before(:each) do
    @study = find_or_factory(:study, :name => "Default Study")
    @plot = find_or_factory(:plot, :name => "Default Plot", :study_id => @study.id)
  end

  it "should validate uniqueness of name with study" do
    another_study = find_or_factory(:study, :name => "Another Study")
    another_study_plot = another_study.plots.new(:name => "Default Plot")
    assert another_study_plot.valid?

    repeat_name_plot = @study.plots.new(:name => "Default Plot")
    assert !repeat_name_plot.valid?
  end

  describe "a new treatment and replicate with a plot" do
    before(:each) do
      @treatment = find_or_factory(:treatment, :name => "Treatment")
      @replicate = find_or_factory(:replicate, :name => "Replicate")
      @plot = find_or_factory(:plot, :treatment_id => @treatment.id, :replicate_id => @replicate.id)
    end

    it "should be found by Plot.find_by_treatment_and_replicate" do
      assert_equal @plot, Plot.find_by_treatment_and_replicate("Treatment", "Replicate")
    end
  end
end
