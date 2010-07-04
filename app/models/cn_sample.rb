require 'statistics'

class CnSample < ActiveRecord::Base
  has_many :cn_measurements, :include => :run, :order => 'runs.run_date, cn_measurements.id'
  
  has_many :runs, :through => :cn_measurements, :order => 'run_date'
end
