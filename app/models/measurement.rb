#Represents a single measurement, e.g. an amount of carbon or nitric acid.
class Measurement < ActiveRecord::Base
  before_save :change_negative_to_zero

  belongs_to :analyte
  belongs_to :sample
  belongs_to :run
  
  validates_presence_of :amount
  validates_presence_of :analyte
  validates_presence_of :sample

  def sample_date
    self.sample.sample_date
  end

  # change number to zero unless they are more that 0.01 negative
  # in which case we need to investigate.
  def change_negative_to_zero
    if amount < 0 && amount > -0.01
      amount = 0
    end
  end
end
