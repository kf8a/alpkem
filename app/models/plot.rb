# frozen_string_literal: true

# Represents the specific location that a set of measurements are taken from.
class Plot < ActiveRecord::Base
  belongs_to :study, optional: true
  belongs_to :treatment, optional: true
  belongs_to :replicate, optional: true
  belongs_to :station, optional: true
  has_many :samples

  validates :name, uniqueness: { scope: :study_id }

  def treatment_name
    treatment.name
  end

  def replicate_name
    replicate.name
  end
end
