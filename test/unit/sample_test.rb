require 'test_helper'

class SampleTest < ActiveSupport::TestCase

  should validate_presence_of :plot

  context "plot_name method" do
    setup do
      @sample = Factory.create(:sample)
    end

    should "return the name of the plot" do
      assert @sample.plot_name == @sample.plot.name
    end
  end
  
  context "previous_measurements method" do
    context "with some previous approved measurements for the same plot" do
      setup do
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
        new_plot = Factory.create(:plot, :name => "Different")
        @wrong_plot_sample = Factory.create(:sample,
             :sample_date => 1.year.ago.to_date,
             :plot => new_plot,
             :approved => true)
        @prev_wrong_plot = Factory.create(:measurement, :sample => @wrong_plot_sample)
        @prev_deleted = Factory.create(:measurement, :sample => @prev_sample, :deleted => true)
      end

      should "list those previous measurements" do
        assert @sample.previous_measurements.include?(@prev_approved1)
        assert @sample.previous_measurements.include?(@prev_approved2)
      end

      should "not list unapproved measurements" do
        assert !@sample.previous_measurements.include?(@prev_unapproved)
      end

      should "not list measurements from other plots" do
        assert !@sample.previous_measurements.include?(@prev_wrong_plot)
      end

      should "not list measurements which were deleted" do
        assert !@sample.previous_measurements.include?(@prev_deleted)
      end
    end
  end

  context "analytes method" do
    setup do
      @sample = Factory.create(:sample)
    end
    
    should "include NO3" do
      no3 = Analyte.find_by_name("NO3")
      assert @sample.analytes.include?(no3)
    end

    should "include NH4" do
      nh4 = Analyte.find_by_name("NH4")
      assert @sample.analytes.include?(nh4)
    end
  end
end
