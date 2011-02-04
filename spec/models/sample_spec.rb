require 'spec_helper'

describe Sample do

  describe "validates presence of plot" do
    before(:each) do
      @sample = Factory.create(:sample)
    end

    it "should require plot to be valid" do
      @sample.plot = nil
      assert !@sample.valid?
    end
  end

  describe "plot_name method" do
    before(:each) do
      @sample = Factory.create(:sample)
    end

    it "should return the name of the plot" do
      assert @sample.plot_name == @sample.plot.name
    end
  end
  
  describe "previous_measurements method" do
    describe "with some previous approved measurements for the same plot" do
      before(:each) do
        @sample = Factory.create(:sample, :sample_date => Date.today)
        @prev_sample = Factory.create(:sample,
            :sample_date => 1.year.ago.to_date,
            :plot => @sample.plot,
            :approved => true)
        @prev_approved1 = Factory.create(:measurement, :sample => @prev_sample)
        @prev_approved2 = Factory.create(:measurement, :sample => @prev_sample)
        @unapproved_sample = Factory.create(:sample,
             :sample_date => 1.year.ago.to_date,
             :plot => @sample.plot,
             :approved => false)
        @prev_unapproved = Factory.create(:measurement, :sample => @unapproved_sample)
        new_plot = Factory.create(:plot)
        @wrong_plot_sample = Factory.create(:sample,
             :sample_date => 1.year.ago.to_date,
             :plot => new_plot,
             :approved => true)
        @prev_wrong_plot = Factory.create(:measurement, :sample => @wrong_plot_sample)
        @prev_deleted = Factory.create(:measurement, :sample => @prev_sample, :deleted => true)
      end

      it "should list those previous measurements" do
        assert @sample.previous_measurements.include?(@prev_approved1)
        assert @sample.previous_measurements.include?(@prev_approved2)
      end

      it "should not list unapproved measurements" do
        assert !@sample.previous_measurements.include?(@prev_unapproved)
      end

      it "should not list measurements from other plots" do
        assert !@sample.previous_measurements.include?(@prev_wrong_plot)
      end

      it "should not list measurements which were deleted" do
        assert !@sample.previous_measurements.include?(@prev_deleted)
      end
    end
  end

  describe "analytes method" do
    describe "for an NO3/NH4 type sample" do
      before(:each) do
        @sample = Factory.create(:sample)
        @no3 = find_or_factory(:analyte, :name => "NO3")
        @nh4 = find_or_factory(:analyte, :name => "NH4")
        Factory.create(:measurement, :sample => @sample, :analyte => @no3)
        Factory.create(:measurement, :sample => @sample, :analyte => @nh4)
      end

      it "should include NO3" do
        assert @sample.analytes.include?(@no3)
      end

      it "should include NH4" do
        assert @sample.analytes.include?(@nh4)
      end
    end

    describe "for an N/C type sample" do
      before(:each) do
        @sample = Factory.create(:sample)
        @nitrogen = find_or_factory(:analyte, :name => "N")
        @carbon = find_or_factory(:analyte, :name => "C")
        Factory.create(:measurement, :sample => @sample, :analyte => @nitrogen)
        Factory.create(:measurement, :sample => @sample, :analyte => @carbon)
      end

      it "should include Nitrogen" do
        assert @sample.analytes.include?(@nitrogen)
      end

      it "should include Carbon" do
        assert @sample.analytes.include?(@carbon)
      end
    end
  end

  describe "average method" do
    before(:each) do
      @sample = Factory.create(:sample)
      @no3 = find_or_factory(:analyte, :name => "NO3")
      @nh4 = find_or_factory(:analyte, :name => "NH4")
      @measurement1 = Factory.create(:measurement, :sample => @sample, :amount => 1, :analyte => @no3)
      @measurement2 = Factory.create(:measurement, :sample => @sample, :amount => 2, :analyte => @no3)
      @measurement3 = Factory.create(:measurement, :sample => @sample, :amount => 3, :analyte => @no3)
      @correct_average = (1 + 2 + 3)/3
      @other_analyte_measurement = Factory.create(:measurement, :sample => @sample, :amount => 4, :analyte => @nh4)
      @deleted_measurement = Factory.create(:measurement, :sample => @sample, :amount => 5, :analyte => @no3, :deleted => true)
      @sample.reload
    end

    it "should return the average only of the right measurements" do
      assert_equal @sample.average(@no3), @correct_average
      assert_equal @sample.average(@nh4), 4
    end
  end
end
