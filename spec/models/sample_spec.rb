require 'rails_helper'

describe Sample do
  describe 'validates presence of plot' do
    before(:each) do
      @sample = FactoryBot.create(:sample)
    end

    it 'should require plot to be valid' do
      @sample.plot = nil
      assert !@sample.valid?
    end
  end

  describe 'plot_name method' do
    before(:each) do
      @sample = FactoryBot.create(:sample)
    end

    it 'should return the name of the plot' do
      assert @sample.plot_name == @sample.plot.name
    end
  end

  describe 'previous_measurements method' do
    describe 'with some previous approved measurements for the same plot' do
      before(:each) do
        @sample = FactoryBot.create(:sample, sample_date: Date.today)
        @prev_sample = FactoryBot.create(:sample,
                                          sample_date: 1.year.ago.to_date,
                                          plot: @sample.plot,
                                          workflow_state: 'approved')
        @prev_approved1 = FactoryBot.create(:measurement, sample: @prev_sample)
        @prev_approved2 = FactoryBot.create(:measurement, sample: @prev_sample)
        @unapproved_sample = FactoryBot.create(:sample,
                                                sample_date: 1.year.ago.to_date,
                                                plot: @sample.plot,
                                                workflow_state: 'new')
        @prev_unapproved = FactoryBot.create(:measurement,
                                              sample: @unapproved_sample)
        new_plot = FactoryBot.create(:plot)
        @wrong_plot_sample = FactoryBot.create(:sample,
                                                sample_date: 1.year.ago.to_date,
                                                plot: new_plot,
                                                workflow_state: 'approved')
        @prev_wrong_plot = FactoryBot.create(:measurement,
                                              sample: @wrong_plot_sample)
        @prev_deleted = FactoryBot.create(:measurement,
                                           sample: @prev_sample,
                                           deleted: true)
      end

      it 'should list those previous measurements' do
        assert @sample.previous_measurements.include?(@prev_approved1)
        assert @sample.previous_measurements.include?(@prev_approved2)
      end

      it 'should not list unapproved measurements' do
        assert !@sample.previous_measurements.include?(@prev_unapproved)
      end

      it 'should not list measurements from other plots' do
        assert !@sample.previous_measurements.include?(@prev_wrong_plot)
      end

      it 'should not list measurements which were deleted' do
        assert !@sample.previous_measurements.include?(@prev_deleted)
      end
    end
  end

  describe 'analytes method' do
    describe 'for an NO3/NH4 type sample' do
      before(:each) do
        run = FactoryBot.build(:run_with_measurements)
        run.save
        @sample = FactoryBot.create(:sample)
        @no3 = find_or_factory(:analyte, name: 'NO3')
        @nh4 = find_or_factory(:analyte, name: 'NH4')
        FactoryBot.create(:measurement,
                           sample: @sample,
                           analyte: @no3,
                           run: run)
        FactoryBot.create(:measurement,
                           sample: @sample,
                           analyte: @nh4,
                           run: run)
      end

      it 'should include NO3' do
        assert @sample.analytes.include?(@no3)
      end

      it 'should include NH4' do
        assert @sample.analytes.include?(@nh4)
      end
    end

    describe 'for an N/C type sample' do
      before(:each) do
        @sample = FactoryBot.create(:sample)
        @nitrogen = find_or_factory(:analyte, name: 'N')
        @carbon = find_or_factory(:analyte, name: 'C')
        FactoryBot.create(:measurement, sample: @sample, analyte: @nitrogen)
        FactoryBot.create(:measurement, sample: @sample, analyte: @carbon)
      end

      it 'should include Nitrogen' do
        assert @sample.analytes.include?(@nitrogen)
      end

      it 'should include Carbon' do
        assert @sample.analytes.include?(@carbon)
      end
    end
  end

  describe 'average method' do
    before(:each) do
      @sample = FactoryBot.create(:sample)
      @no3 = find_or_factory(:analyte, name: 'NO3')
      @nh4 = find_or_factory(:analyte, name: 'NH4')
      @measurement1 = FactoryBot.create(:measurement,
                                         sample: @sample,
                                         amount: 1,
                                         analyte: @no3)
      @measurement2 = FactoryBot.create(:measurement,
                                         sample: @sample,
                                         amount: 2,
                                         analyte: @no3)
      @measurement3 = FactoryBot.create(:measurement,
                                         sample: @sample,
                                         amount: 3,
                                         analyte: @no3)
      @correct_average = (1 + 2 + 3) / 3
      @other_analyte_measurement = FactoryBot.create(:measurement,
                                                      sample: @sample,
                                                      amount: 4,
                                                      analyte: @nh4)
      @deleted_measurement = FactoryBot.create(:measurement,
                                                sample: @sample,
                                                amount: 5,
                                                analyte: @no3,
                                                deleted: true)
      @sample.reload
    end

    it 'should return the average only of the right measurements' do
      assert_equal @sample.average(@no3), @correct_average
      assert_equal @sample.average(@nh4), 4
    end
  end

  describe 'workflow states' do
    let(:sample) { FactoryBot.create :sample }
    it 'starts out as new' do
      expect(sample).to be_new
    end
    it 'transitions to approved when approved' do
      sample.approve!
      expect(sample).to be_approved
    end
    it 'transitions from approved to rejected' do
      sample.approve!
      expect(sample).to be_approved
      sample.reject!
      expect(sample).to be_rejected
    end
    it 'transitions from rejected to approved' do
      sample.approve!
      sample.reject!
      sample.approve!
      expect(sample).to be_approved
    end
  end
end
