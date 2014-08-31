#A study is a collection of plots which go together for analysis.
class Study < ActiveRecord::Base
  has_many :treatments
  has_many :replicates
  has_many :plots
  
  validates_uniqueness_of :name

  def create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
    create_treatments(number_of_treatments)
    create_replicates(number_of_replicates, replicate_prefix)

    treatments_and_replicates = self.treatments.product(self.replicates)
    treatments_and_replicates.each do |treatment, replicate|
      Plot.where(:name => "#{treatment.name}#{replicate.name}", :study_id => self).first_or_create(
            :name => "#{treatment.name}#{replicate.name}",
            :study => self,
            :treatment => treatment,
            :replicate => replicate)
    end
  end

  def create_treatments(amount)
    1.upto(amount) do |number|
      self.treatments.find_or_create_by(name: "#{self.prefix}#{number}")
    end
  end

  def create_replicates(amount, prefix)
    1.upto(amount) do |number|
      self.replicates.find_or_create_by(name: "#{prefix}#{number}")
    end
  end

  def update_plots(number_of_treatments, number_of_replicates)
    replicate_prefix = self.replicates.first.name.chop
    create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
  end
end
