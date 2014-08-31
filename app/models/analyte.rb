# Represents the component that is analyzed in the measurements
# for example NO3, NH4, C, or N
class Analyte < ActiveRecord::Base
  has_many :measurements
  has_many :cn_measurements
  has_many :runs, through: :measurements
end
