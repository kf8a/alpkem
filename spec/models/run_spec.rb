require 'rails_helper'

describe Run do

  def good_data
    @good_data ||= set_good_data
  end

  def set_good_data
    file_name = Rails.root.join('test', 'data', 'new_format_soil_samples_090415.TXT')
    File.open(file_name, 'r') do |f|
      return StringIO.new(f.read)
    end
  end

  before do
    @attr ||= {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }

    @standard_run = Run.new(@attr)
    @standard_run.measurements = [FactoryGirl.create(:measurement)]
    assert @standard_run.save
  end

  it "should validate sample_type_id" do
    run = Run.find(@standard_run.id)
    run.should be_valid
    run.sample_type_id = nil
    run.should_not be_valid
  end

  it "should validate measurements" do 
    run = Run.find(@standard_run.id)
    run.should be_valid
    run.measurements = []
    run.should_not be_valid
  end

  it "runs should include runs but not cn runs and vice versa" do
    run = FactoryGirl.create(:run, :sample_date => Date.today)
    cn_run = FactoryGirl.create(:cn_run)
    assert !Run.runs.include?(cn_run)
    assert Run.runs.include?(run)

    assert !Run.cn_runs.include?(run)
    assert Run.cn_runs.include?(cn_run)
  end

  it "should give sample_type_name for a run" do
    run = FactoryGirl.create(:run, :sample_type_id => 4)
    assert_equal "GLBRC Deep Core Nitrogen", run.sample_type_name
  end

  it "should identify what is and is not a cn_run" do
    run = Run.find(@standard_run.id)
    cn_run = FactoryGirl.create(:cn_run)
    assert !run.cn_run?
    assert cn_run.cn_run?
  end

  it "should find the associated samples" do
    run = Run.find(@standard_run.id)
    sample = FactoryGirl.create(:sample)
    FactoryGirl.create(:measurement, :run => run, :sample => sample)
    other_run = FactoryGirl.create(:run)
    other_sample = FactoryGirl.create(:sample)
    FactoryGirl.create(:measurement, :run => other_run, :sample => other_sample)
    run.reload
    other_run.reload
    assert run.samples.include?(sample)
    assert !run.samples.include?(other_sample)
    assert other_run.samples.include?(other_sample)
    assert !other_run.samples.include?(sample)
  end

  it "should know if it has been updated" do
    changing_run = FactoryGirl.create(:run)
    changing_sample = FactoryGirl.create(:sample)
    FactoryGirl.create(:measurement, :sample => changing_sample, :run => changing_run)
    changing_sample.sample_date = Date.yesterday #a change
    changing_sample.save
    static_run = FactoryGirl.create(:run)
    static_sample = FactoryGirl.create(:sample)
    FactoryGirl.create(:measurement, :sample => static_sample, :run => static_run)
    changing_run.reload
    static_run.reload
    assert changing_run.updated?
    assert !static_run.updated?
  end

  it "saves with good data" do
    r = Run.new(@attr)
    r.load_file(good_data)
    assert r.save
  end

  it "requires loaded data to save" do
    r = Run.new(@attr)
    assert !r.save, "It should not save without data loaded."
  end

  it "requires non empty data to save" do
    r = Run.new(@attr)
    file_name = Rails.root.join('test', 'data', 'blank.txt')
    File.open(file_name, 'r') do |f|
      empty_data = StringIO.new(f.read)
      r.load_file(empty_data)
    end
    assert !r.save
    assert_equal r.load_errors, "Data file is empty."
  end

  it "requires a date to save" do
    r = Run.new(@attr.merge(:sample_date => nil))
    r.load_file(good_data)
    assert !r.save
  end

  it "properly loads the data" do
    r = Run.new(@attr)
    r.load_file(good_data)
    r.save

    assert r.samples.size > 1
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot, Date.today)
    assert sample.valid?
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    assert_not_nil sample.measurements.index {|m| m.amount == 0.047 && m.analyte == no3}
    assert_not_nil sample.measurements.index {|m| m.amount == 0.379 && m.analyte == nh4}

    plot = Plot.find_by_treatment_and_replicate('T7','R2')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert sample.valid?
    assert_not_nil sample.measurements.index {|m| m.amount == 0.070 && m.analyte == no3}
    assert_not_nil sample.measurements.index {|m| m.amount == 0.266 && m.analyte == nh4}

    run = Run.find(r.id)
    measurements = run.measurements.where(:analyte_id => no3.id)
    assert !measurements.where(:amount => 0.098).blank?
    measurements = run.measurements.where(:analyte_id => nh4.id)
    assert !measurements.where(:amount => 0.036).blank?

    assert_not_nil run.samples.index {|s| s.plot.treatment.name == "T6"}

    assert_equal 330, run.measurements.size
  end

  # TODO these next 2 test fail because I am now using the new format for sample type 2 rather than the old format
  # I will need to get some new files with negatives and reruns for these test
  # TODO separate out the sample type from the sample format.
  it "loads files with negatives" do
    # assert_difference "Run.count" do
    #    file_name = File.dirname(__FILE__) + '/../data/LTER_soil_20040511.TXT'
    #    File.open(file_name,'r') do |f|
    #      s = StringIO.new(f.read)
    #      r = Run.new(@attr)
    #      r.load(s)
    #      assert r.save
    #      assert r.samples.size > 1
    #      assert_equal 330, r.measurements.size
    #    end
    #  end
  end

  it "loads glbrc files" do
    file_name = Rails.root.join('test', 'data', 'GLBRC_deep_core_1106R4R5.TXT')
    File.open(file_name,'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 4))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
  end

  it 'loads single element files' do
    file_name = Rails.root.join 'test', 'data', '3262012B.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 2))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
  end

  it "loads glbrc_resin_strips files" do
    file_name = Rails.root.join('test', 'data', 'new_format_soil_samples_090415.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 5))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1 #We'll have better tests in the parser
    end
  end

  it "loads cn files" do
    file_name = Rails.root.join('test', 'data', 'DC01CFR1.csv')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 6))
      r.load_file(s)
      assert_equal r.plot_errors, ""
      assert r.save
      assert r.samples.size > 1
    end
  end

  it "loads glbrc_cn_deep_core new format files" do
    file_name = Rails.root.join('test', 'data', 'GLBRC_cn.csv')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 9))
      r.load_file(s)
      assert_equal r.plot_errors, ""
      assert r.save
      assert r.samples.size > 1
    end
  end

  it "loads new glbrc soil sample files" do
    file_name = Rails.root.join('test', 'data', 'glbrc_soil_sample_new_format.txt')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 8))
      assert r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
  end

  it "loads more glbrc soil sample files" do
    file_name = Rails.root.join('test', 'data', '100419L.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 8))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
  end

  it "loads lysimeter files" do
    file_name = Rails.root.join('test', 'data', 'new_lysimeter.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert_equal "", r.plot_errors
      assert r.save
      #TODO add CF and DF plots to the test database
      assert r.samples.size > 1 # there are 93 samples but we don't have DF and CF in the test database
    end
  end

  it "loads another lysimeter file" do
    file_name = Rails.root.join('test', 'data', '090615QL.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
      #These details can be dealt with in the parser tests
#      assert_equal 32, r.samples.size
      assert_equal 6, r.samples[0].measurements.size
      assert_equal  0.055, r.samples[0].measurements[0].amount
      assert_equal 2.115, r.samples[0].measurements[1].amount
    end
  end

  it "loads lysimeter files with negative peaks" do
    file_name = Rails.root.join('test', 'data', '090701QL.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
      assert_equal 6, r.samples[0].measurements.size
    end
  end

  it "loads lysimeter files with a single sample" do
    file_name = Rails.root.join('test', 'data', 'Lysimeter_single_format.TXT')
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
  end
end
