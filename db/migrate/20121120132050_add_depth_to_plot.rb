class AddDepthToPlot < ActiveRecord::Migration[4.2]
  def change
    add_column :plots, :top_depth, :float
    add_column :plots, :bottom_depth, :float
  end
end
