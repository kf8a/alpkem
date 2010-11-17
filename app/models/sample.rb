require 'statistics'

# This repesents one field sample such as a soil core or a water sample
class Sample < ActiveRecord::Base
  belongs_to :plot

  has_many :measurements, :include => :run, :order => 'runs.run_date, measurements.id'
  has_many :runs, :through => :measurements, :order => 'run_date'
  has_many :analytes, :through => :measurements
  
  validates_presence_of :plot
  
  scope :approved, where(%q{approved = 't'})
  
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

  def Sample.all_analytes
    Sample.all.collect {|sample| sample.analytes}.flatten.uniq.compact
  end

  def Sample.csv_titles
    titles = ['sample_id','sample_date','treatment','replicate']
    Sample.all_analytes.each do |analyte|
      titles << "#{analyte.name}_#{analyte.unit}"
    end
    titles
  end

  def to_array
    sample_array = [self.id,
                    self.sample_date.to_s,
                    self.plot.treatment.name,
                    self.plot.replicate.name]

    Sample.all_analytes.each do |analyte|
      sample_array << self.average(analyte)
    end
    sample_array
  end
  
  def plot_name
    self.plot.try(:name)
  end
  
  def previous_measurements
    approved_samples = Sample.approved
    approved_samples.keep_if {|sample| sample.sample_date}
    approved_samples.keep_if {|sample| sample.plot == self.plot}
    relevant_measurements = approved_samples.collect {|sample| sample.measurements}.flatten
    relevant_measurements.keep_if {|measurement| !measurement.deleted}
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
