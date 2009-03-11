require 'statistics'

class Sample < ActiveRecord::Base
  belongs_to :plot
  belongs_to :sample_type
  has_many :measurements, :order => 'id'
  
  def measurements_by_analyte_name(analyte_name)
    analyte = Analyte.find_by_name(:first, analyte_name)
    measurements_by_analyte(analyte)
  end
  
  def measurements_by_analyte(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.find(:all, :conditions => [%q{analyte_id = ?}, analyte.id])
  end
  
  def average(analyte)
    raise ArgumentError unless analyte.class == Analyte
    measurements.average(:amount, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
  end
  
  def cv(analyte)
    raise ArgumentError unless analyte.class == Analyte
    m = measurements.find(:all, :conditions => [%q{analyte_id = ? and deleted = 'f'}, analyte.id])
    Statistics.cv(m.map {|x| x.amount})
  end

  def Sample.find_approved()
    Sample.find(:all, :conditions => [%q{approved = 't'}])
  end
  
end
