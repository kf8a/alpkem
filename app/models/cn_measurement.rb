class CnMeasurement < ActiveRecord::Base

  belongs_to :analyte
  belongs_to :cn_sample
  belongs_to :run
  
  validates :amount,    :presence => true
  validates :analyte,   :presence => true
  validates :cn_sample, :presence => true

  def self.real_plots
    self.all.collect {|measurement| measurement.cn_plot if measurement.plot_is_real?}
  end

  def plot_is_real?
    !self.cn_plot.blank? &&
        !self.cn_plot.include?("Standard") &&
        !self.cn_plot.include?("Blindstd")
  end

  def sample
    return cn_sample
  end
  
end