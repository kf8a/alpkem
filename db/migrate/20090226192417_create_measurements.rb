class CreateMeasurements < ActiveRecord::Migration
  def self.up
    create_table :measurements do |t|
      t.integer :run_id
      t.integer :sample_id
      t.integer :analyte_id
      t.float :amount
      t.boolean :deleted, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :measurements
  end
end
