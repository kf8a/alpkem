class DestroyCnSamplesAndCnMeasurements < ActiveRecord::Migration
  def self.up
    drop_table :cn_samples
    drop_table :cn_measurements
  end

  def self.down
    # not much we can do to restore deleted data
    raise ActiveRecord::IrreversibleMigration, "Can't recover the deleted tables"
  end
end
