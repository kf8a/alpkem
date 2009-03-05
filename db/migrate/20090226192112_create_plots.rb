class CreatePlots < ActiveRecord::Migration
  def self.up
    create_table :plots do |t|
      t.string :name
      t.integer :study_id
      t.integer :treatment_id
      t.integer :replicate_id
    end

    
    Plot.reset_column_information
    studies = Study.find(:all)
    studies.each do |study|
      study.treatments.each do |treatment|
        replicates = Replicate.find_all_by_study_id(study)
        replicates.each do |replicate|
          p = Plot.create({:name => "#{treatment.name}#{replicate.name}", :study => study, :treatment => treatment, :replicate => replicate}).save
        end
      end
    end
    
    add_index :plots, :treatment_id
    add_index :plots, :replicate_id

  end

  def self.down
    drop_table :plots
  end
end
