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

  def self.find_or_create_with_metadata(opts)
    plot = Plot.find_or_create_by(name: opts[:name], study_id: opts[:study_id])
    metadata = opts[:metadata]
    plot.treatment_name = metadata[:treatment]
    plot.replicate_name = metadata[:replicate]
    plot.site_code = metadata[:site]
    plot.sub_plot = metadata[:subplot]
    plot.top_depth = metadata[:top_depth]
    plot.bottom_depth = metadata[:bottom_depth]
    plot.save
    plot
  end
end
