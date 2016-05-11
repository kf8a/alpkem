# Samples and runs each belong to a sample type, which determines parsing behavior.
class SampleType < ActiveRecord::Base
  has_many :samples
  has_many :runs

  def self.sample_type_options
    where(active: true).collect { |type| [type.name, type.id.to_s] }
  end
end
