class Measurement < ActiveRecord::Base

  belongs_to :analyte
  belongs_to :sample
  belongs_to :run
  
  validates_presence_of :amount
  validates_presence_of :analyte
  validates_presence_of :sample
  
end
