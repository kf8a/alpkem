class CreateReplicates < ActiveRecord::Migration
  def self.up
    create_table :replicates do |t|
      t.string :name
      t.integer :study_id
    end
    
    Replicate.reset_column_information
    
    1.upto(6) do |i|
      Replicate.create({:name => "R#{i}", :study_id => 1})
    end
    1.upto(5) do |i|
      Replicate.create({:name => "R#{i}", :study_id => 2})
    end
    
  end

  def self.down
    drop_table :replicates
  end
end
