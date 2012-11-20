class AddStationToPlots < ActiveRecord::Migration
  def change
    add_column :plots, :station_id, :integer
  end
end
