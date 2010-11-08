class CnMeasurement < ActiveRecord::Base

  belongs_to :analyte
  belongs_to :cn_sample
  belongs_to :run
  
  validates :amount,    :presence => true
  validates :analyte,   :presence => true
  validates :cn_sample, :presence => true

  def sample
    return cn_sample
  end

  def copy_to_sample(new_sample)
    @measurement = Measurement.new
    @measurement.run_id = self.run_id
    @measurement.sample_id = new_sample.id
    @measurement.analyte_id = self.analyte_id
    @measurement.amount = self.amount
    @measurement.deleted = self.deleted
    @measurement.save
  end
end