class SampleType < ActiveRecord::Base
  has_many :samples
  has_many :runs
end
