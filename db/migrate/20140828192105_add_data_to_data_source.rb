class AddDataToDataSource < ActiveRecord::Migration[5.2]
  def change
    add_column :data_sources, :data, :string
  end
end
