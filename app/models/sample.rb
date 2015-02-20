require 'statistics'

# This repesents one field sample such as a soil core or a water sample
class Sample < ActiveRecord::Base
  belongs_to :plot

  has_many :measurements #, -> {include(:runs, :measurements).order('runs.run_date, measurements.id') }
  has_many :runs, -> {order('run_date')}, through: :measurements
  has_many :analytes, :through => :measurements
  belongs_to :sample_type

  validates_presence_of :plot

  scope :approved, ->  {where(workflow_state: 'approved')}

  include Workflow

  workflow do
    state :new do
      event :approve, transitions_to: :approved
    end
    state :approved do
      event :revert,  transitions_to: :new
      event :reject, transitions_to: :rejected
    end
    state :rejected do
      event :approve, transitions_to: :approved
    end
  end


  def Sample.samples_to_csv(samples)
    CSV.generate do |csv|
      csv << csv_titles
      samples.each {|sample| csv << sample.to_array}
    end
  end

  def plot_name
    self.plot.try(:name)
  end

  def previous_measurements
    right_samples = Sample.approved.where(:plot_id => self.plot.id).to_a
    right_samples.keep_if {|sample| sample.sample_date}
    right_samples.collect {|sample| sample.measurements.where(:deleted => false)}.flatten
  end

  def average(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.where(%q{analyte_id = ? and deleted = 'f'}, analyte.id).average(:amount)
  end

  def cv(analyte)
    raise ArgumentError unless analyte.class == Analyte
    variance = measurements.where(%q{analyte_id = ? and deleted = 'f'}, analyte.id).calculate(:variance, :amount)
    variance/average
  end

  def toggle_approval
    if self.approved?
      self.revert!
    else
      self.approve!
    end
  end

  def unapprove
    if self.rejected?
      self.revert!
      self.revert!
    end
    if self.approved?
      self.revert!
    end
  end

  def updated?
    self.updated_at > self.created_at
  end

  private##########################

  def Sample.all_analytes
    all.collect {|sample| sample.analytes}.flatten.uniq.compact.sort
  end

  def Sample.csv_titles
    titles = ['sample_id','sample_date','treatment','replicate']
    all_analytes.each { |analyte| titles << "#{analyte.name}_#{analyte.unit}" }

    titles
  end

  def to_array
    sample_array = [self.id,
                    self.sample_date.to_s,
                    self.plot.treatment.name,
                    self.plot.replicate.name]

    Sample.all_analytes.each { |analyte| sample_array << self.average(analyte) }

    sample_array
  end

end
