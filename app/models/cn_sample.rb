require 'statistics'

class CnSample < ActiveRecord::Base
  has_many :cn_measurements, :include => :run, :order => 'runs.run_date, cn_measurements.id'
  
  has_many :runs, :through => :cn_measurements, :order => 'run_date'

  def plot_name
    return cn_plot
  end
  
  def analytes
    list_of_analytes = []
    analyte_percent_n = Analyte.find_by_name('N')
    analyte_percent_c = Analyte.find_by_name('C')
    list_of_analytes << analyte_percent_n
    list_of_analytes << analyte_percent_c
    return list_of_analytes
  end
  
  def measurements_by_analyte_name(analyte_name)
    analyte = Analyte.find_by_name(:first, analyte_name)
    measurements_by_analyte(analyte)
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte   
    cn_measurements.find(:all, :conditions => [%q{analyte_id = ?}, analyte.id])
  end
  
  def average(analyte)
    raise ArgumentError unless analyte.class == Analyte
    cn_measurements.average(:amount, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
  end
  
  def cv(analyte)
    raise ArgumentError unless analyte.class == Analyte
    m = cn_measurements.find(:all, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
    Statistics.cv(m.map {|x| x.amount})
  end

  def CnSample.find_approved()
    CnSample.find(:all, :conditions => [%q{approved = 't'}])
  end
end
