require 'statistics'

class CnSample < ActiveRecord::Base

  has_many :cn_measurements, :include => :run, :order => 'runs.run_date, cn_measurements.id'
  has_many :runs, :through => :cn_measurements, :order => 'run_date'

  validates_presence_of :cn_plot
  
  scope :approved, where(%q{approved = 't'})
  

  def plot_name
    return self.cn_plot
  end
  
  def analytes
    list_of_analytes = []
    analyte_percent_n = Analyte.find_by_name('N')
    analyte_percent_c = Analyte.find_by_name('C')
    list_of_analytes << analyte_percent_n
    list_of_analytes << analyte_percent_c
    return list_of_analytes
  end

  def previous_measurements
    approved_samples = CnSample.approved
    relevant_measurements = []
    approved_samples.each do |a|
      next unless a.cn_plot == cn_plot
      next unless a.sample_date
      a.cn_measurements.each do |m|
        next if m.deleted?
        relevant_measurements << m
      end
    end
    return relevant_measurements
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte   
    cn_measurements.where(%q{analyte_id = ?}, analyte.id)
  end
  
  def average(analyte)
    raise ArgumentError unless analyte.class == Analyte
    cn_measurements.average(:amount, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
  end
  
  def cv(analyte)
    raise ArgumentError unless analyte.class == Analyte
    m = cn_measurements.where(%q{analyte_id = ? and deleted = 'f'}, analyte.id)
    Statistics.cv(m.map {|x| x.amount})
  end

end
