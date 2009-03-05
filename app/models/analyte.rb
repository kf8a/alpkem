class Analyte < ActiveRecord::Base
  has_many :measurements
end
