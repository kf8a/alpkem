class AddExplicitNamesToPlots < ActiveRecord::Migration[4.2]
  def change
    add_column :plots, :sub_plot, :text
    add_column :plots, :treatment, :text
    add_column :plots, :replicate, :text
  end
end
