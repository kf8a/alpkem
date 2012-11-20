#Represents the specific location that a set of measurements are taken from.
class Plot < ActiveRecord::Base
  belongs_to :study
  belongs_to :treatment
  belongs_to :replicate
  belongs_to :station
  has_many :samples

  validates_uniqueness_of :name, :scope => :study_id
  
  def Plot.find_by_treatment_and_replicate(treatment_string, replicate_string)
    trt = Treatment.find_by_name(treatment_string)
    rep = Replicate.find_by_name(replicate_string)
    Plot.find_by_treatment_id_and_replicate_id(trt.id, rep.id)
  end
end
