class AddStationToPlots < ActiveRecord::Migration[4.2]
  def change
    add_column :plots, :station_id, :integer
  end
end
