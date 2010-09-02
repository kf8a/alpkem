class Measurement < ActiveRecord::Base
  belongs_to :sample
  belongs_to :run
  belongs_to :analyte
  
  validates_presence_of :analyte
  validates_presence_of :sample
  validates_presence_of :amount
  
  def Measurement.find_all_good_measurements()
    Measurement.find(:all, :conditions => ['deleted = false'])
  end
 
end
