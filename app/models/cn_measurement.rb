class CnMeasurement < ActiveRecord::Base

  belongs_to :analyte
  belongs_to :cn_sample
  belongs_to :run
  
  validates_presence_of :amount
  validates_presence_of :analyte
  validates_presence_of :cn_sample
  
  def sample
    return cn_sample
  end
  
end