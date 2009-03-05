class Measurement < ActiveRecord::Base
  belongs_to :sample
  belongs_to :run
  belongs_to :analyte
  
  validates_presence_of :analyte
  validates_presence_of :sample
  
  def Measurement.find_all_good_measurements()
    Measurement.find(:all, :conditions => ['deleted = false'])
  end
 
end
