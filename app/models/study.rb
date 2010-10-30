class Study < ActiveRecord::Base
  has_many :treatments
  has_many :replicates
  has_many :plots
  
  validates_uniqueness_of :name

  def create_plots(number_of_treatments, number_of_replicates, replicate_prefix)
    1.upto(number_of_treatments) do |i|
      Treatment.find_or_create_by_name_and_study_id(:name => "#{self.prefix}#{i}", :study_id => self.id)
    end

    1.upto(number_of_replicates) do |i|
      Replicate.find_or_create_by_name_and_study_id(:name => "#{replicate_prefix}#{i}", :study_id => self.id)
    end

    self.treatments.each do |treatment|
      replicates = Replicate.find_all_by_study_id(self)
      replicates.each do |replicate|
        Plot.find_or_create_by_name_and_study_id(:name => "#{treatment.name}#{replicate.name}", :study => self, :treatment => treatment, :replicate => replicate)
      end
    end
  end
end
