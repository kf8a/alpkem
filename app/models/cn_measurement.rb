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
  
end