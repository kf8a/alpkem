#A study is a collection of plots which go together for analysis.
class Study < ActiveRecord::Base
  has_many :treatments
  has_many :replicates
  has_many :plots
  
  validates_uniqueness_of :name

  def create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
    create_treatments(number_of_treatments)
    create_replicates(number_of_replicates, replicate_prefix)

    self.treatments.each do |treatment|
      self.replicates.each do |replicate|
        Plot.find_or_create_by_name_and_study_id(
            :name => "#{treatment.name}#{replicate.name}",
            :study => self,
            :treatment => treatment,
            :replicate => replicate)
      end
    end
  end

  def create_treatments(amount)
    1.upto(amount) do |number|
      Treatment.find_or_create_by_name_and_study_id(
          :name => "#{self.prefix}#{number}",
          :study_id => self.id)
    end
  end

  def create_replicates(amount, prefix)
    1.upto(amount) do |number|
      Replicate.find_or_create_by_name_and_study_id(
          :name => "#{prefix}#{number}",
          :study_id => self.id)
    end
  end

  def update_plots(number_of_treatments, number_of_replicates)
    replicate_prefix = self.replicates.first.name.chop
    create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
  end
end
