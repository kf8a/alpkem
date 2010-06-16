require 'test_helper'

require 'date'

class RunTest < Test::Unit::TestCase

  def test_presence_of_sample_type
    r = Run.new
    assert !r.save
    r.sample_type = SampleType.find(:first)
    assert r.save
  end
  
  def test_with_date
    r = Run.new
    r.sample_date = Date.today.to_s
    r.sample_type = SampleType.find_by_id(1)
    assert r.save
  end

  def test_file_load
    assert_equal 0, Run.count
    file_name = File.dirname(__FILE__) + '/../data/test.TXT'
    File.open(file_name,'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new
      r.sample_date = Date.today.to_s
      r.sample_type = SampleType.find(2)
      r.load(s)
      assert r.save
      assert r.samples.size > 1
    end

    assert_equal 1, Run.count
    
    plot = Plot.find_by_treatment_and_replicate('T7', 'R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert_valid(sample)
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')
    assert_equal 0.053056531, sample.measurements_by_analyte(no3)[0].amount
    assert_equal 0.295276523, sample.measurements_by_analyte(nh4)[0].amount
    
    plot = Plot.find_by_treatment_and_replicate('T7','R2')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    assert_not_nil sample
    assert_valid sample
    assert_equal 0.081048779, sample.measurements_by_analyte(no3)[0].amount
    assert_equal 0.302532285, sample.measurements_by_analyte(nh4)[0].amount
    
    run = Run.find(:first)
    assert_equal 0.169466645, run.measurements_by_analyte(no3)[0].amount
    assert_equal 0.209936038, run.measurements_by_analyte(nh4)[0].amount
    
    assert_equal "T6", run.samples[run.samples.size-1].plot.treatment.name
    
    assert_equal 6, run.samples[0].measurements.size # only the current runs measurements are returned.
    assert_equal 330, run.measurements.size
  end
  
  def test_file_load_with_negatives
    old_runs = Run.count
     file_name = File.dirname(__FILE__) + '/../data/20040511.TXT'
     File.open(file_name,'r') do |f|
       s = StringIO.new(f.read)
       r = Run.new
       r.sample_date = Date.today.to_s
       r.sample_type = SampleType.find(2)
       r.load(s)
       assert r.save
       assert r.samples.size > 1
       assert_equal 330, r.measurements.size
     end

     assert_equal old_runs+1, Run.count
  end
  
  def test_file_load_with_reruns
    old_runs = Run.count
    plot = Plot.find_by_treatment_and_replicate('T1','R1')
    sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
    
    old_measurements =  sample.measurements.count
     file_name = File.dirname(__FILE__) + '/../data/20041102.TXT'
     File.open(file_name,'r') do |f|
       s = StringIO.new(f.read)
       r = Run.new
       r.sample_date = Date.today.to_s
       r.sample_type = SampleType.find(2)
       r.load(s)
       assert r.save
       assert r.samples.size > 1
       assert_equal 342, r.measurements.size
     end

     assert_equal old_runs + 1, Run.count  
     plot = Plot.find_by_treatment_and_replicate('T1','R1')
     sample = Sample.find_by_plot_id_and_sample_date(plot.id, Date.today.to_s)
   
     assert_equal old_measurements + 8, sample.measurements.count
  end
  
  def test_glbrc_file_load
    old_runs = Run.count
    file_name = File.dirname(__FILE__) + '/../data/1106R4R5.TXT'
    File.open(file_name,'r') do |f|
      s = StringIO.new(f.read)
      r = Run.new
      r.sample_date = Date.today.to_s
      r.sample_type = SampleType.find(4)
      r.load(s,4)
      assert r.save
      assert r.samples.size > 1
    end
    assert_equal old_runs + 1, Run.count
  end
end
