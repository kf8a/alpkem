require 'spec_helper'

describe CnSample do
  it { should validate_presence_of(:cn_plot) }

  describe 'plot_name method' do
    before(:each) do
      @sample = Factory.create(:cn_sample)
    end

    it 'should return the name of the plot' do
      assert @sample.plot_name == @sample.cn_plot
    end
  end

  describe "previous_measurements method" do
    describe "with some previous approved measurements for the same plot" do
      before(:each) do
        @sample = Factory.create(:cn_sample, :sample_date => Date.today)
        @prev_sample = Factory.create(:cn_sample,
            :sample_date => 1.year.ago.to_date,
            :cn_plot => @sample.cn_plot,
            :approved => true)
        @prev_approved1 = Factory.create(:cn_measurement, :cn_sample => @prev_sample)
        @prev_approved2 = Factory.create(:cn_measurement, :cn_sample => @prev_sample)
        @unapproved_sample = Factory.create(:cn_sample,
             :sample_date => 1.year.ago.to_date,
             :cn_plot => @sample.cn_plot,
             :approved => false)
        @prev_unapproved = Factory.create(:cn_measurement, :cn_sample => @unapproved_sample)
        new_plot = "Different"
        @wrong_plot_sample = Factory.create(:cn_sample,
             :sample_date => 1.year.ago.to_date,
             :cn_plot => new_plot,
             :approved => true)
        @prev_wrong_plot = Factory.create(:cn_measurement, :cn_sample => @wrong_plot_sample)
        @prev_deleted = Factory.create(:cn_measurement, :cn_sample => @prev_sample, :deleted => true)
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
    before(:each) do
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

