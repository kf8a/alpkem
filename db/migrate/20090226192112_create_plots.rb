class CreatePlots < ActiveRecord::Migration[4.2]
  def self.up
    create_table :plots do |t|
      t.string :name
      t.integer :study_id
      t.integer :treatment_id
      t.integer :replicate_id
      t.string :species_code
    end
    add_index :plots, :treatment_id
    add_index :plots, :replicate_id

  end

  def self.down
    drop_table :plots
  end
end
