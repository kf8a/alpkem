class CreateDataSources < ActiveRecord::Migration[4.2]
  def change
    create_table :data_sources do |t|
      t.integer :run_id
      t.timestamps
    end
  end
end
