require 'test_helper'
require 'minitest/autorun'

describe CnSample do
  #TODO Rewrite this if necessary
  #it { should validate_presence_of(:cn_plot) }

  describe 'plot_name method' do
    before do
      @sample = find_or_factory(:cn_sample)
    end

    it 'should return the name of the plot' do
      assert @sample.plot_name == @sample.cn_plot
    end
  end

  describe "previous_measurements method" do
    describe "with some previous approved measurements for the same plot" do
      before do
        @sample = find_or_factory(:cn_sample, :sample_date => Date.today)
        @prev_sample = find_or_factory(:cn_sample,
            :sample_date => 1.year.ago.to_date,
            :cn_plot => @sample.cn_plot,
            :approved => true)
        @prev_approved1 = find_or_factory(:cn_measurement, :cn_sample_id => @prev_sample.id)
        @prev_approved2 = find_or_factory(:cn_measurement, :cn_sample_id => @prev_sample.id)
        @unapproved_sample = find_or_factory(:cn_sample,
             :sample_date => 1.year.ago.to_date,
             :cn_plot => @sample.cn_plot,
             :approved => false)
        @prev_unapproved = find_or_factory(:cn_measurement, :cn_sample_id => @unapproved_sample.id)
        new_plot = "Different"
        @wrong_plot_sample = Factory.create(:cn_sample,
             :sample_date => 1.year.ago.to_date,
             :cn_plot => new_plot,
             :approved => true)
        @prev_wrong_plot = find_or_factory(:cn_measurement, :cn_sample_id => @wrong_plot_sample.id)
        @prev_deleted = find_or_factory(:cn_measurement, :cn_sample_id => @prev_sample.id, :deleted => true)
      end

      it 'should list those previous measurements' do
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
    before do
      @sample = Factory.create(:cn_sample)
    end

    it "should include NO3" do
      n = Analyte.find_by_name("N")
      assert @sample.analytes.include?(n)
    end

    it "should include NH4" do
      c = Analyte.find_by_name("C")
      assert @sample.analytes.include?(c)
    end
  end
end
