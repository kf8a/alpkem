# Represents the specific location that a set of measurements are taken from.
class Plot < ActiveRecord::Base
  belongs_to :study
  belongs_to :treatment
  belongs_to :replicate
  belongs_to :station
  has_many :samples

  validates :name, uniqueness: { scope: :study_id }

  def treatment_name
    treatment.name
  end

  def replicate_name
    replicate.name
  end
end
