class CreateReplicates < ActiveRecord::Migration
  def self.up
    create_table :replicates do |t|
      t.string :name
      t.integer :study_id
    end
  end

  def self.down
    drop_table :replicates
  end
end
