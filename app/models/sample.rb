require 'statistics'

# This repesents one field sample such as a soil core or a water sample
class Sample < ActiveRecord::Base
  belongs_to :plot
  belongs_to :sample_type

  has_many :measurements, :include => :run, :order => 'runs.run_date, measurements.id'
  has_many :runs, :through => :measurements, :order => 'run_date'
  
  validates_presence_of :plot
  
  scope :approved, where(%q{approved = 't'})
  
  attr_reader :analytes
  
  def initialize
    super
      analyte_no3       = Analyte.find_by_name('NO3')
      analyte_nh4       = Analyte.find_by_name('NH4')

      @analytes = [analyte_no3, analyte_nh4]
  end

  def Sample.samples_to_csv(samples)
    unless samples.blank?
      CSV.generate do |csv|
        csv << ['sample_id','sample_date','treatment','replicate','no3_ppm','nh4_ppm']
        samples.each do |sample|
          csv << sample.to_array
        end
      end
    end
  end

  def to_array
    no3 = Analyte.find_by_name('NO3')
    nh4 = Analyte.find_by_name('NH4')

    [self.id,
     self.sample_date.to_s,
     self.plot.treatment.name,
     self.plot.replicate.name,
     self.average(no3),
     self.average(nh4)]
  end
  
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
 
  #TODO This method is only used in tests now, so rewrite those tests and delete method.
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
    variance = measurements.calculate(:variance, :amount,  :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
    variance/average
  end
end
