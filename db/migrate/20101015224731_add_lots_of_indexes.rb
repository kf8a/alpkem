class AddLotsOfIndexes < ActiveRecord::Migration
  def self.up
    add_index :cn_measurements,         :run_id
    add_index :cn_measurements,         :cn_sample_id
    add_index :cn_measurements,         :analyte_id
    add_index :measurements,            :run_id
    add_index :measurements,            :sample_id
    add_index :measurements,            :analyte_id
    add_index :plots,                   :study_id
    add_index :replicates,              :study_id
    add_index :runs,                    :sample_type_id
    add_index :samples,                 :sample_type_id
    add_index :treatments,              :study_id
  end

  def self.down
    remove_index :cn_measurements,         :run_id
    remove_index :cn_measurements,         :cn_sample_id
    remove_index :cn_measurements,         :analyte_id
    remove_index :measurements,            :run_id
    remove_index :measurements,            :sample_id
    remove_index :measurements,            :analyte_id
    remove_index :plots,                   :study_id
    remove_index :replicates,              :study_id
    remove_index :runs,                    :sample_type_id
    remove_index :samples,                 :sample_type_id
    remove_index :treatments,              :study_id
  end
end
