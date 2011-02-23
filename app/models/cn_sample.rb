require 'statistics'

#DEPRECATED: This model represented samples with Carbon or Nitrogen measurements,
#but these have now been incorporated into the Sample model.
class CnSample < ActiveRecord::Base

  has_many :cn_measurements, :include => :run, :order => 'runs.run_date, cn_measurements.id'
  has_many :runs, :through => :cn_measurements, :order => 'run_date'

  validates_presence_of :cn_plot
  
  scope :approved, where(%q{approved = 't'})

  def convert_all_to_samples
    CnSample.all.each {|sample| sample.convert_to_sample}
  end
  
  def copy_all_without_destroying
    CnSample.all.each {|sample| sample.copy_without_destroying}
  end

  def copy_without_destroying
    if self.plot_is_real?
      if self.cn_measurements.count > 0
        if self.get_sample_type_id
          if self.cn_plot_to_plot #ensures there really is a plot by that name
            self.copy_to_sample #ensures that measurements and sample transfer
          end
        end
      end
    end
  end

  def convert_to_sample
    if self.bad_plot_name?
      self.destroy
    elsif self.cn_measurements.blank?
      self.destroy
    elsif self.get_sample_type_id.nil?
      self.destroy
    elsif self.cn_plot_to_plot #ensures there really is a plot by that name
      if self.copy_to_sample #ensures that measurements and sample transfer
        self.destroy
      end
    end
  end

  def copy_to_sample
    @sample = Sample.new
    @sample.plot_id = self.cn_plot_to_plot
    @sample.sample_type_id = self.get_sample_type_id
    @sample.sample_date = self.sample_date
    @sample.approved = self.approved
    @sample.created_at = self.created_at
    @sample.save
    p @sample
    p @sample.errors
    self.cn_measurements.each {|measurement| measurement.copy_to_sample(@sample)}
    @sample.reload
    @sample.measurements.count == self.cn_measurements.count
  end
  
  def cn_plot_to_plot
    Plot.find_by_name(self.cn_plot).try(:id)
  end
  
  def get_sample_type_id
    self.cn_measurements.first.run.try(:sample_type_id)
  end

  def plot_is_real?
    !self.cn_plot.blank? &&
          !self.cn_plot.include?("Standard") &&
          !self.cn_plot.include?("Blindstd")
  end

  def bad_plot_name?
    !self.plot_is_real?
  end

  def plot_id_for_cn_plot

  end

  def plot_name
    return self.cn_plot
  end
  
  def analytes
    analyte_percent_n = Analyte.find_by_name('N')
    analyte_percent_c = Analyte.find_by_name('C')
    [analyte_percent_n, analyte_percent_c]
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
