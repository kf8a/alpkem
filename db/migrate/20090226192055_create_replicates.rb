class CreateReplicates < ActiveRecord::Migration[4.2]
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
