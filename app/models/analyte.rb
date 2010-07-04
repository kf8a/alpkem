class Analyte < ActiveRecord::Base
  has_many :measurements
  has_many :cn_measurements
end
