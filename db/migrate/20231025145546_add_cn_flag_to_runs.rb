class AddCnFlagToRuns < ActiveRecord::Migration[6.1]
  def change
    create_table :run_types do |t|
      t.string :name
      t.timestamps
    end

    add_column :runs, :run_type_id, :int
    add_foreign_key :runs, :run_types, column: :run_type, primary_key: :id

  end
end
