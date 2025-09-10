# frozen_string_literal: true

require 'rails_helper'

describe Run, type: :model do
  it { should have_many :measurements }

  def good_data
    @good_data ||= set_good_data
  end

  def set_good_data
    file_name = Rails.root.join('spec', 'fixtures', 'files', 'new_format_soil_samples_090415.TXT')
    File.open(file_name, 'r') do |f|
      return StringIO.new(f.read)
    end
  end

  before do
    run_type = FactoryBot.create(:run_type, name: 'CN')
    @attr ||= { sample_type_id: 2,
                run_type_id: run_type.id,
                sample_date: Date.today.to_s }

    @standard_run = FactoryBot.build(:run, @attr)
    @standard_run.measurements = [FactoryBot.build(:measurement)]
    assert @standard_run.save
  end

  it 'should validate sample_type_id' do
    run = Run.find(@standard_run.id)
    assert run.valid?
    run.sample_type_id = nil
    assert !run.valid?
  end

  it 'validates measurements' do
    run = Run.find(@standard_run.id)
    assert run.valid?
    run.measurements = []
    assert !run.valid?
  end

  it 'runs should include runs but not cn runs and vice versa' do
    run = FactoryBot.build(:run_with_measurements, sample_date: Date.today)
    run.save
    cn_run = FactoryBot.create(:cn_run_with_measurements)
    cn_run.save
    assert !Run.runs.include?(cn_run)
    assert Run.runs.include?(run)

    assert !Run.cn_runs.include?(run)
    assert Run.cn_runs.include?(cn_run)
  end

  it 'should give sample_type_name for a run' do
    run = FactoryBot.build(:run_with_measurements, sample_type_id: 4)
    assert_equal 'GLBRC Deep Core Nitrogen', run.sample_type_name
  end

  it 'should identify what is and is not a cn_run' do
    run = Run.find(@standard_run.id)
    cn_run = FactoryBot.build(:cn_run_with_measurements)
    assert !run.cn_run?
    assert cn_run.cn_run?
  end

  it 'should find the associated samples' do
    run = Run.find(@standard_run.id)
    sample = FactoryBot.create(:sample)
    FactoryBot.create(:measurement, run: run, sample: sample)
    other_run = FactoryBot.build(:run_with_measurements)
    other_run.save
    other_sample = FactoryBot.create(:sample)
    FactoryBot.create(:measurement, run: other_run, sample: other_sample)
    run.reload
    other_run.reload
    assert run.samples.include?(sample)
    assert !run.samples.include?(other_sample)
    assert other_run.samples.include?(other_sample)
    assert !other_run.samples.include?(sample)
  end

  it 'should know if it has been updated' do
    changing_run = FactoryBot.build(:run_with_measurements)
    changing_run.save
    changing_sample = FactoryBot.create(:sample)
    FactoryBot.create(:measurement, sample: changing_sample, run: changing_run)
    changing_sample.sample_date = Date.yesterday # a change
    changing_sample.save
    static_run = FactoryBot.build(:run_with_measurements)
    static_run.save
    static_sample = FactoryBot.create(:sample)
    FactoryBot.create(:measurement, sample: static_sample, run: static_run)
    changing_run.reload
    static_run.reload
    assert changing_run.updated?
    assert !static_run.updated?
  end

  it 'saves with good data' do
    r = FactoryBot.build(:run, @attr)
    r.load_file(good_data)
    assert r.save
  end

  it 'requires loaded data to save' do
    r = FactoryBot.build(:run, @attr.merge(measurements: []))
    assert !r.save, 'It should not save without data loaded.'
  end

  it 'requires non empty data to save' do
    r = FactoryBot.build(:run, @attr)
    file_name = Rails.root.join('spec', 'fixtures','files', 'blank.txt')
    File.open(file_name, 'r') do |f|
      empty_data = StringIO.new(f.read)
      r.load_file(empty_data)
    end
    assert !r.save
    assert_equal r.load_errors, 'Data file is empty.'
    r.destroy
  end

  it 'requires a date to save' do
    r = FactoryBot.build(:run, @attr.merge(sample_date: nil))
    r.load_file(good_data)
    assert !r.save
    r.destroy
  end

  it 'properly loads the data' do
    r = FactoryBot.build(:run, @attr)
    r.load_file(good_data)
    assert r.save

    assert r.samples.size > 1
    plot = Plot.find_by(name: 'T7R1')
    sample = Sample.find_by(plot_id: plot.id, sample_date: Date.today)
    assert sample.valid?
    no3 = Analyte.find_by(name: 'NO3')
    nh4 = Analyte.find_by(name: 'NH4')
    expect(sample.measurements.index {|m| m.amount == 0.047 && m.analyte == no3}).to_not be_nil
    expect(sample.measurements.index {|m| m.amount == 0.379 && m.analyte == nh4}).to_not be_nil

    plot = Plot.find_by(name: 'T7R2')
    sample = Sample.find_by(plot_id: plot.id, sample_date: Date.today.to_s)
    expect(sample).to_not be_nil
    assert sample.valid?
    expect(sample.measurements.index {|m| m.amount == 0.070 && m.analyte == no3}).to_not be_nil
    expect(sample.measurements.index {|m| m.amount == 0.266 && m.analyte == nh4}).to_not be_nil

    run = Run.find(r.id)
    measurements = run.measurements.where(analyte_id: no3.id)
    assert !measurements.where(amount: 0.098).blank?
    measurements = run.measurements.where(analyte_id: nh4.id)
    assert !measurements.where(amount: 0.036).blank?

    expect(run.samples.index {|s| s.plot.treatment.name == 'T6'}).to_not be_nil

    assert_equal 276, run.measurements.size
    r.destroy
  end

  # TODO: these next 2 test fail because I am now using the new format for sample type 2 rather than the old format
  # I will need to get some new files with negatives and reruns for these test
  # TODO: separate out the sample type from the sample format.
  it 'loads files with negatives' do
    # assert_difference 'Run.count' do
    #    file_name = File.dirname(__FILE__) + '/../data/LTER_soil_20040511.TXT'
    #    File.open(file_name,'r') do |f|
    #      s = StringIO.new(f.read)
    #      r = FactoryBot.build(:run, @attr)
    #      r.load(s)
    #      assert r.save
    #      assert r.samples.size > 1
    #      assert_equal 330, r.measurements.size
    #    end
    #  end
  end

  it 'loads glbrc files' do
    file_name = Rails.root.join('test', 'data', 'GLBRC_deep_core_1106R4R5.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 4))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads single element files' do
    file_name = Rails.root.join 'spec', 'fixtures', 'files', '3262012B.TXT'
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 2))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads glbrc_resin_strips files' do
    file_name = Rails.root.join('spec', 'fixtures','files', 'new_format_soil_samples_090415.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 5))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1 # We'll have better tests in the parser
    r.destroy
  end

  it 'loads cn files' do
    file_name = Rails.root.join('test', 'data', 'DC01CFR1.csv')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 6))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert_equal r.plot_errors, ''
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads glbrc_cn_deep_core new format files' do
    file_name = Rails.root.join('test', 'data', 'GLBRC_cn.csv')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 9))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
      assert_equal r.plot_errors, ''
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads new glbrc soil sample files' do
    file_name = Rails.root.join('test', 'data', 'glbrc_soil_sample_new_format.txt')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 8))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      assert r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads more glbrc soil sample files' do
    file_name = Rails.root.join('test', 'data', '100419L.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 8))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads lysimeter files' do
    file_name = Rails.root.join('test', 'data', 'new_lysimeter.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 1))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert_equal '', r.plot_errors
    assert r.save
    # TODO: add CF and DF plots to the test database
    assert r.samples.size > 1 # there are 93 samples but we don't have DF and CF in the test database
    r.destroy
  end

  it 'loads another lysimeter file' do
    file_name = Rails.root.join('test', 'data', '090615QL.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 1))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  it 'loads lysimeter files with negative peaks' do
    file_name = Rails.root.join('test', 'data', '090701QL.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 1))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    assert_equal 6, r.samples[0].measurements.size
    r.destroy
  end

  it 'loads lysimeter files with a single sample' do
    file_name = Rails.root.join('test', 'data', 'Lysimeter_single_format.TXT')
    r = FactoryBot.build(:run, @attr.merge(sample_type_id: 1))
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r.load_file(s)
    end
    assert r.save
    assert r.samples.size > 1
    r.destroy
  end

  describe 'deleting' do
    it 'deletes measurements' do
      file_name = Rails.root.join('test', 'data', 'new_lysimeter.TXT')
      r = FactoryBot.build(:run, @attr.merge(sample_type_id: 1))
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r.load_file(s)
        # TODO: add CF and DF plots to the test database
      end
      assert_equal '', r.plot_errors
      assert r.save
      assert r.samples.size > 1 # there are 93 samples but we don't have DF and CF in the test database
      measurements = r.measurements
      assert measurements.size > 1
      r.destroy
      assert measurements.empty?
    end
  end
end
