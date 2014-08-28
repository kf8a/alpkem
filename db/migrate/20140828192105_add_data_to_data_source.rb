class AddDataToDataSource < ActiveRecord::Migration
  def change
    add_column :data_sources, :data, :string
  end
end
