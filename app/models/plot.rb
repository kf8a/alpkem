# Represents the specific location that a set of measurements are taken from.
class Plot < ActiveRecord::Base
  belongs_to :study
  belongs_to :treatment
  belongs_to :replicate
  belongs_to :station
  has_many :samples

  validates :name, uniqueness: { scope: :study_id }

  def self.find_by_treatment_and_replicate(treatment_string, replicate_string)
    trt = Treatment.find_by_(name: treatment_string)
    rep = Replicate.find_by(name: replicate_string)
    Plot.find_by(treatment_id: trt.id, replicate_id: rep.id)
  end
end
