#Samples and runs each belong to a sample type, which determines parsing behavior.
class SampleType < ActiveRecord::Base
  has_many :samples
  has_many :runs

  def SampleType.sample_type_options
    self.where(active: true).all.collect { |type| [type.name, type.id.to_s] }
  end
end
