class Study < ActiveRecord::Base
  has_many :treatments
  has_many :replicates
  has_many :plots
  
  validates_uniqueness_of :name
end
