require 'test_helper'
require 'minitest/autorun'

describe Run do

  def good_data
    @good_data ||= set_good_data
  end

  def set_good_data
    file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
    File.open(file_name, 'r') do |f|
      return StringIO.new(f.read)
    end
  end

  def load_data_if_necessary
    @plot ||= Plot.find_by_name("DCL01S01010")
    if @plot.nil?
      load "#{Rails.root}/db/seeds.rb"
    end
  end

  before do
    @attr ||= {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
    load_data_if_necessary
  end

  it "should validate sample_type_id and measurements" do
    run = Factory.create(:run)
    assert run.valid?
    run.sample_type_id = nil
    refute run.valid?

    run = Factory.create(:run)
    assert run.valid?
    run.measurements = []
    refute run.valid?
  end

  it "runs should include runs but not cn runs" do
    Run.all.each {|r| r.destroy}
    middle = Factory.create(:run, :sample_date => Date.today)
    earliest = Factory.create(:run, :sample_date => Date.today - 20)
    latest = Factory.create(:run, :sample_date => Date.tomorrow)
    cn_run = Factory.create(:cn_run)
    refute Run.runs.include?(cn_run)
    assert_equal Run.runs, [earliest, middle, latest]
  end

  it "cn_runs should include cn runs but not runs" do
    Run.all.each {|r| r.destroy}
    run = Factory.create(:run, :sample_date => Date.today)
    middle = Factory.create(:cn_run, :sample_date => Date.today)
    latest = Factory.create(:cn_run, :sample_date => Date.today + 20)
    earliest = Factory.create(:cn_run, :sample_date => Date.today - 10)
    refute Run.cn_runs.include?(run)
    assert_equal Run.cn_runs, [earliest, middle, latest]
  end

  it "should have the right sample_type_options" do
    assert_equal Run.sample_type_options,
        [["Lysimeter", "1"],
        ["Soil Sample", "2"],
        ["GLBRC Soil Sample", "3"],
        ["GLBRC Deep Core Nitrogen", "4"],
        ["GLBRC Resin Strips", "5"],
        ["CN Soil Sample", "6"],
        ["CN Deep Core", "7"],
        ["GLBRC Soil Sample (New)", "8"],
        ["GLBRC CN", "9"], 
        ["Lysimeter NO3", "10"],
        ["Lysimeter NH4", "11"]]
  end

  it "should convert sample_type_id to name" do
    assert_equal "Lysimeter", Run.sample_type_id_to_name(1)
    assert_equal "Soil Sample", Run.sample_type_id_to_name(2)
    assert_equal "GLBRC Soil Sample", Run.sample_type_id_to_name(3)
    assert_equal "GLBRC Deep Core Nitrogen", Run.sample_type_id_to_name(4)
    assert_equal "GLBRC Resin Strips", Run.sample_type_id_to_name(5)
    assert_equal "CN Soil Sample", Run.sample_type_id_to_name(6)
    assert_equal "CN Deep Core", Run.sample_type_id_to_name(7)
    assert_equal "GLBRC Soil Sample (New)", Run.sample_type_id_to_name(8)
    assert_equal "GLBRC CN", Run.sample_type_id_to_name(9)
    assert_equal "Lysimeter NO3", Run.sample_type_id_to_name(10)
    assert_equal "Lysimeter NH4", Run.sample_type_id_to_name(11)
  end

  it "should provide the name of its sample type" do
    run = Factory.create(:run, :sample_type_id => 4)
    assert_equal "GLBRC Deep Core Nitrogen", run.sample_type_name
  end

  it "should identify what is and is not a cn_run" do
    run = Factory.create(:run)
    cn_run = Factory.create(:cn_run)
    refute run.cn_run?
    assert cn_run.cn_run?
  end

  it "should find measurements by analyte" do
    run = Factory.create(:run)
    water = Factory.create(:analyte, :name => "H2O")
    sugar = Factory.create(:analyte, :name => "C6H12O6")
    water_measurement = Factory.create(:measurement, :run => run, :analyte => water)
    sugar_measurement = Factory.create(:measurement, :run => run, :analyte => sugar)
    assert_equal run.measurements_by_analyte(water), [water_measurement]
    assert_equal run.measurements_by_analyte(sugar), [sugar_measurement]
  end

  it "should find measurement by id" do
    run = Factory.create(:run)
    measurement = Factory.create(:measurement, :run => run)
    measurement2 = Factory.create(:measurement, :run => run)
    assert_equal run.measurement_by_id(measurement.id), measurement
    assert_equal run.measurement_by_id(measurement2.id), measurement2
  end

  it "should find the associated samples" do
    run = Factory.create(:run)
    sample = Factory.create(:sample)
    Factory.create(:measurement, :run => run, :sample => sample)
    other_run = Factory.create(:run)
    other_sample = Factory.create(:sample)
    Factory.create(:measurement, :run => other_run, :sample => other_sample)
    run.reload
    other_run.reload
    assert run.samples.include?(sample)
    refute run.samples.include?(other_sample)
    assert other_run.samples.include?(other_sample)
    refute other_run.samples.include?(sample)
  end

  it "should find a sample by id" do
    run = Factory.create(:run)
    sample = Factory.create(:sample)
    Factory.create(:measurement, :run => run, :sample => sample)
    run.reload
    assert_equal run.sample_by_id(sample.id), sample
  end

  it "should know if it has been updated" do
    changing_run = Factory.create(:run)
    changing_sample = Factory.create(:sample)
    Factory.create(:measurement, :sample => changing_sample, :run => changing_run)
    changing_sample.sample_date = Date.yesterday #a change
    changing_sample.save
    static_run = Factory.create(:run)
    static_sample = Factory.create(:sample)
    Factory.create(:measurement, :sample => static_sample, :run => static_run)
    changing_run.reload
    static_run.reload
    assert changing_run.updated?
    refute static_run.updated?
  end

  it "saves with good data" do
    run_count = Run.count
    r = Run.new(@attr)
    r.load_file(good_data)
    assert r.save
    assert_equal run_count + 1, Run.count
  end

  it "requires loaded data to save" do
    r = Run.new(@attr)
    assert !r.save, "It should not save without data loaded."
  end

  it "requires non empty data to save" do
    r = Run.new(@attr)
    file_name = File.dirname(__FILE__) + '/../data/blank.txt'
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
    refute_nil sample
    assert sample.valid?
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    refute_nil sample.measurements.index {|m| m.amount == 0.047 && m.analyte == no3}
    refute_nil sample.measurements.index {|m| m.amount == 0.379 && m.analyte == nh4}

    plot = Plot.find_by_treatment_and_replicate('T7','R2')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    refute_nil sample
    assert sample.valid?
    refute_nil sample.measurements.index {|m| m.amount == 0.070 && m.analyte == no3}
    refute_nil sample.measurements.index {|m| m.amount == 0.266 && m.analyte == nh4}

    run = Run.find(r.id)
    measurements = run.measurements_by_analyte(no3)
    refute_nil measurements.index {|m| m.amount == 0.098}
    measurements = run.measurements_by_analyte(nh4)
    refute_nil measurements.index {|m| m.amount == 0.036}

    refute_nil run.samples.index {|s| s.plot.treatment.name == "T6"}

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

  it "loads files with reruns" do
    # assert_difference "Run.count" do
    #    file_name = File.dirname(__FILE__) + '/../data/LTER_soil_20041102.TXT'
    #    File.open(file_name,'r') do |f|
    #      s = StringIO.new(f.read)
    #      r = Run.new(@attr)
    #      r.load(s)
    #      assert r.save
    #      assert r.samples.size > 1
    #      assert_equal 342, r.measurements.size
    #    end
    #  end
  end

  it "loads glbrc files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/GLBRC_deep_core_1106R4R5.TXT'
    File.open(file_name,'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 4))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end

  it "loads glbrc_resin_strips files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 5))
      r.load_file(s)
      assert r.save
      assert_equal 38, r.samples.size
    end
    assert_equal run_count + 1, Run.count
  end

  it "loads cn files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/DC01CFR1.csv'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 6))
      r.load_file(s)
      assert_equal r.plot_errors, ""
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end

  it "loads cn_deep_core files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/GLBRC_CN_deepcore.csv'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 7))
      r.load_file(s)
      assert_equal r.plot_errors, ""
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end
  
  it "loads glbrc_cn_deep_core new format files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/GLBRC_cn.csv'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 9))
      r.load_file(s)
      assert_equal r.plot_errors, ""
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end

  it "loads new glbrc soil sample files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/glbrc_soil_sample_new_format.txt'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 8))
      assert r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end

  it "loads more glbrc soil sample files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/100419L.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 8))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end
  
  it "loads lysimeter files" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/new_lysimeter.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      #TODO add CF and DF plots to the test database
      assert_equal 29, r.samples.size # there are 93 samples but we don't have DF and CF in the test database
    end
    assert_equal run_count + 1, Run.count
  end
  
  it "loads another lysimeter file" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + "/../data/090615QL.TXT"
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert_equal 32, r.samples.size
      assert_equal 6, r.samples[0].measurements.size
      assert_equal  0.055, r.samples[0].measurements[0].amount
      assert_equal 2.115, r.samples[0].measurements[1].amount
    end
    assert_equal run_count + 1, Run.count
  end
  
  it "loads lysimeter files with negative peaks" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + "/../data/090701QL.TXT"
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert_equal 38, r.samples.size
      assert_equal 6, r.samples[0].measurements.size
    end
    assert_equal run_count + 1, Run.count
  end
  
  
  it "loads lysimeter files with a single sample" do
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/Lysimeter_single_format.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 10))
      r.load_file(s)
      assert r.save
      assert_equal 38, r.samples.size
    end
    assert_equal run_count + 1, Run.count
  end
end
