class CreateTreatments < ActiveRecord::Migration
  def self.up
    create_table :treatments do |t|
      t.string :name
      t.integer :study_id
    end
    add_index :treatments, :name
    
    Treatment.reset_column_information
    1.upto(8) do |i|
      Treatment.create({:name => "T#{i}", :study_id => 1})
    end
    Treatment.create({:name => 'TDF', :study_id => 1})
    Treatment.create({:name => 'TSF', :study_id => 1})
    Treatment.create({:name => 'TCF', :study_id => 1})
    Treatment.create({:name => 'T21', :study_id => 1})

    1.upto(10) do |i|
      Treatment.create({:name => "G#{i}", :study_id => 2})
    end
  end

  def self.down
    drop_table :treatments
  end
end
