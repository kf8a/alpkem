class GlbrcDeepSamples < ActiveRecord::Migration
  def self.up
    study = Study.find_by_name('glbrc')
    study.treatments.each do |treatment|
      replicates = Replicate.find_all_by_study_id(study)
      replicates.each do |replicate|
        1.upto(3) do |station|
          [10,25].each do |depth|
            Plot.create({:name => "#{treatment.name}#{replicate.name}S#{station}#{depth}", :study => study,
            :treatment => treatment, :replicate => replicate})
          end
        end
      end
    end
  end

  def self.down
  end
end
