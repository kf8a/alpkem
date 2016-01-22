class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.integer :run_id
      t.timestamps, null: true
    end
  end
end
