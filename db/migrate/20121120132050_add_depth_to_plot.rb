class AddDepthToPlot < ActiveRecord::Migration
  def change
    add_column :plots, :top_depth, :float
    add_column :plots, :bottom_depth, :float
  end
end
