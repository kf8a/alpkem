class CreateStations < ActiveRecord::Migration[4.2]
  def change
    create_table :stations do |t|
      t.string :name
      t.timestamps
    end
  end
end
