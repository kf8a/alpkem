require 'test_helper'

class RunTest < ActiveSupport::TestCase

  def good_data
    file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
    File.open(file_name, 'r') do |f|
      return StringIO.new(f.read)
    end
  end

  def setup
    @attr = {
      :sample_type_id => 2,
      :sample_date    => Date.today.to_s
    }
  end

  def teardown
    Run.all.each {|r| r.destroy}
  end

  def test_saves_with_good_data
    assert_difference "Run.count" do
      r = Run.new(@attr)
      r.load(good_data)
      assert r.save
    end
  end

  def test_load_requires_sample_type
    r = Run.new(@attr.merge(:sample_type_id => nil))
    assert !r.load(good_data)
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
      r.load(empty_data)
    end
    assert !r.save
    assert_equal r.load_errors, "Data file is empty."
  end

  def test_save_requires_date
    r = Run.new(@attr.merge(:sample_date => nil))
    r.load(good_data)
    assert !r.save
  end

  def test_file_load_data
    r = Run.new(@attr)
    r.load(good_data)
    r.save

    assert r.samples.size > 1   
    #r.samples.each {|o| p o}
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot, Date.today)
    assert_not_nil sample
    assert_valid(sample)
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    measurements = sample.measurements_by_analyte(no3)
    assert_not_nil measurements.index {|m| m.amount == 0.047}
    measurements = sample.measurements_by_analyte(nh4)
    assert_not_nil measurements.index {|m| m.amount == 0.379}

    plot = Plot.find_by_treatment_and_replicate('T7','R2')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert_valid sample
    measurements = sample.measurements_by_analyte(no3)
    assert_not_nil measurements.index {|m| m.amount == 0.070}
    measurements = sample.measurements_by_analyte(nh4)
    assert_not_nil measurements.index {|m| m.amount == 0.266}

    run = Run.find(:first)
    measurements = run.measurements_by_analyte(no3)
    assert_not_nil measurements.index {|m| m.amount == 0.098}
    measurements = run.measurements_by_analyte(nh4)
    assert_not_nil measurements.index {|m| m.amount == 0.036}

    assert_not_nil run.samples.index {|s| s.plot.treatment.name == "T6"}

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
    assert_difference "Run.count" do
      file_name = File.dirname(__FILE__) + '/../data/GLBRC_deep_core_1106R4R5.TXT'
      File.open(file_name,'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 4))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end

  def test_glbrc_resin_strips_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/new_format_soil_samples_090415.TXT'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 5))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end

  def test_cn_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/DC01CFR1.csv'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 6))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end

  def test_cn_deep_core_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/GLBRC_CN_deepcore.csv'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 7))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end

  def test_new_glbrc_soil_sample_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/glbrc_soil_sample_new_format.txt'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 8))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end

  def test_another_glbrc_soil_sample_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/100419L.TXT'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 8))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end
  
  def test_lysimeter_sample_file_load
    assert_difference 'Run.count' do
      file_name = File.dirname(__FILE__) + '/../data/new_lysimeter.TXT'
      File.open(file_name, 'r') do |f|
        s = StringIO.new(f.read)
        r = Run.new(@attr.merge(:sample_type_id => 1))
        r.load(s)
        assert r.save
        assert r.samples.size > 1
      end
    end
  end
end
