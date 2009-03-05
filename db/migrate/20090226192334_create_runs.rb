class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.date :run_date
      t.date :sample_date
      t.integer :sample_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :runs
  end
end
