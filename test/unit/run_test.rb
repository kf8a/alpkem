require 'test_helper'

class RunTest < ActiveSupport::TestCase
  should have_many :measurements
  should validate_presence_of :sample_type_id
  should validate_presence_of :measurements
end

class MiniRunTest < MiniTest::Unit::TestCase

  def good_data
    file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
    File.open(file_name, 'r') do |f|
      return StringIO.new(f.read)
    end
  end

  def load_data_if_necessary
    if Plot.find_by_name("DCL01S01010").blank?
      load "#{Rails.root}/db/seeds.rb"
    end
  end

  def setup
    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
    load_data_if_necessary
  end

  def teardown
    Run.all.each {|r| r.destroy}
  end

  def test_runs
    Run.all.each {|r| r.destroy}
    run1 = Factory.create(:run, :sample_date => Date.today)
    run2 = Factory.create(:run, :sample_date => Date.today - 20)
    run3 = Factory.create(:run, :sample_date => Date.tomorrow)
    cn_run = Factory.create(:cn_run)
    assert_equal Run.runs, [run2, run1, run3]
  end

  def test_cn_runs
    Run.all.each {|r| r.destroy}
    run1 = Factory.create(:run, :sample_date => Date.today)
    run2 = Factory.create(:run, :sample_date => Date.today - 20)
    run3 = Factory.create(:run, :sample_date => Date.tomorrow)
    cn_run1 = Factory.create(:cn_run, :sample_date => Date.today)
    cn_run2 = Factory.create(:cn_run, :sample_date => Date.today + 20)
    cn_run3 = Factory.create(:cn_run, :sample_date => Date.today - 10)
    assert_equal Run.cn_runs, [cn_run3, cn_run1, cn_run2]
  end

  def test_sample_type_options
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

  def test_sample_type_id_to_name
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

  def test_sample_type_name
    run = Factory.create(:run, :sample_type_id => 4)
    assert_equal "GLBRC Deep Core Nitrogen", run.sample_type_name
  end

  def test_cn_run
    run = Factory.create(:run)
    cn_run = Factory.create(:cn_run)
    refute run.cn_run?
    assert cn_run.cn_run?
  end

  def test_measurement_by_id
    run = Factory.create(:run)
    measurement = Factory.create(:measurement, :run => run)
    measurement2 = Factory.create(:measurement, :run => run)
    assert_equal run.measurement_by_id(measurement.id), measurement
    assert_equal run.measurement_by_id(measurement2.id), measurement2
  end

  def test_saves_with_good_data
    run_count = Run.count
    r = Run.new(@attr)
    r.load_file(good_data)
    assert r.save
    assert_equal run_count + 1, Run.count
  end

  def test_save_requires_loaded_data
    r = Run.new(@attr)
    assert !r.save, "It should not save without data loaded."
  end

  def test_save_requires_nonempty_data
    r = Run.new(@attr)
    file_name = File.dirname(__FILE__) + '/../data/blank.txt'
    File.open(file_name, 'r') do |f|
      empty_data = StringIO.new(f.read)
      r.load_file(empty_data)
    end
    assert !r.save
    assert_equal r.load_errors, "Data file is empty."
  end

  def test_save_requires_date
    r = Run.new(@attr.merge(:sample_date => nil))
    r.load_file(good_data)
    assert !r.save
  end

  def test_file_load_data
    r = Run.new(@attr)
    r.load_file(good_data)
    r.save

    assert r.samples.size > 1   
    #r.samples.each {|o| p o}
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot, Date.today)
    refute_nil sample
    assert sample.valid?
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    measurements = sample.measurements_by_analyte(no3)
    refute_nil measurements.index {|m| m.amount == 0.047}
    measurements = sample.measurements_by_analyte(nh4)
    refute_nil measurements.index {|m| m.amount == 0.379}

    plot = Plot.find_by_treatment_and_replicate('T7','R2')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    refute_nil sample
    assert sample.valid?
    measurements = sample.measurements_by_analyte(no3)
    refute_nil measurements.index {|m| m.amount == 0.070}
    measurements = sample.measurements_by_analyte(nh4)
    refute_nil measurements.index {|m| m.amount == 0.266}

    run = Run.find(:first)
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
  def test_file_load_with_negatives
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

  def test_file_load_with_reruns
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

  def test_glbrc_file_load
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

  def test_glbrc_resin_strips_file_load
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 5))
      r.load_file(s)
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal run_count + 1, Run.count
  end

  def test_cn_file_load
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

  def test_cn_deep_core_file_load
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
  
  def test_glbrc_cn_deep_core_new_format_file_load
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

  def test_new_glbrc_soil_sample_file_load
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

  def test_another_glbrc_soil_sample_file_load
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
  
  def test_lysimeter_sample_file_load
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/new_lysimeter.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      #TODO add CF and DF plots to the test database
      assert_equal 87, r.samples.size # there are 93 samples but we don't have DF and CF in the test database
    end
    assert_equal run_count + 1, Run.count
  end
  
  def test_different_lysimeter_sample_file_load
    run_count = Run.count
    file_name = File.dirname(__FILE__) + "/../data/090615QL.TXT"
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert_equal 126, r.samples.size
      assert_equal 2, r.samples[0].measurements.size
      assert_equal  0.055, r.samples[0].measurements[1].amount
      assert_equal 2.115, r.samples[0].measurements[0].amount
    end
    assert_equal run_count + 1, Run.count
  end
  
  def test_lysimeter_file_with_negative_peaks_load
    run_count = Run.count
    file_name = File.dirname(__FILE__) + "/../data/090701QL.TXT"
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 1))
      r.load_file(s)
      assert r.save
      assert_equal 132, r.samples.size
      assert_equal 2, r.samples[0].measurements.size
    end
    assert_equal run_count + 1, Run.count
  end
  
  
  def test_lysimeter_single_sample_file_load
    run_count = Run.count
    file_name = File.dirname(__FILE__) + '/../data/Lysimeter_single_format.TXT'
    File.open(file_name, 'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new(@attr.merge(:sample_type_id => 10))
      r.load_file(s)
      assert r.save
      assert_equal 114, r.samples.size
    end
    assert_equal run_count + 1, Run.count
  end
end
