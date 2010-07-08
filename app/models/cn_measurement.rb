class CnMeasurement < ActiveRecord::Base
  belongs_to :cn_sample
  belongs_to :run
  belongs_to :analyte
  
  validates_presence_of :analyte
  validates_presence_of :cn_sample
  
  def CnMeasurement.find_all_good_measurements()
    CnMeasurement.find(:all, :conditions => ['deleted = false'])
  end

end