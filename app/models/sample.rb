require 'statistics'

class Sample < ActiveRecord::Base
  belongs_to :plot

  has_many :measurements, :include => :run, :order => 'runs.run_date, measurements.id'
  has_many :runs, :through => :measurements, :order => 'run_date'
  
  validates_presence_of :plot
  
  scope :approved, where(%q{approved = 't'})
  
  def plot_name
    self.plot.try(:name)
  end
  
  def previous_measurements
    approved_samples = Sample.approved
    relevant_measurements = []
    approved_samples.each do |a|
      next unless a.plot == self.plot
      next unless a.sample_date
      a.measurements.each do |m|
        next if m.deleted?
        relevant_measurements << m
      end
    end
    return relevant_measurements
  end
  
  def analytes
    list_of_analytes = []
    analyte_no3       = Analyte.find_by_name('NO3')
    analyte_nh4       = Analyte.find_by_name('NH4')
    list_of_analytes << analyte_no3
    list_of_analytes << analyte_nh4
    return list_of_analytes
  end

  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte   
    measurements.where(%q{analyte_id = ?}, analyte.id)
  end
  
  def average(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.average(:amount, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
  end
  
  def cv(analyte)
    raise ArgumentError unless analyte.class == Analyte
    m = measurements.where(%q{analyte_id = ? and deleted = 'f'}, analyte.id)
    Statistics.cv(m.map {|x| x.amount})
  end
 
end
