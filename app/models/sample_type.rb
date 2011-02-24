class SampleType < ActiveRecord::Base
  has_many :samples
  has_many :runs

  def SampleType.sample_type_options
    self.all.collect { |type| [type.name, type.id.to_s] }
  end
end
