class CreateCnMeasurements < ActiveRecord::Migration
  def self.up
    create_table :cn_measurements do |t|
      t.integer  "run_id"
      t.integer  "cn_sample_id"
      t.integer  "analyte_id"
      t.float    "amount"
      t.boolean  "deleted",    :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cn_measurements
  end
end
