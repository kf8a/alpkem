class RemoveExtraniousIndexes < ActiveRecord::Migration
  # these tables are not big enough to benefit from indexing
  def self.up
    remove_index :plots,                   :study_id
    remove_index :plots,                   :replicate_id
    remove_index :plots,                   :treatment_id
    remove_index :replicates,              :study_id
    remove_index :treatments,              :study_id
    remove_index :treatments,              :name
  end

  def self.down
  end
end
