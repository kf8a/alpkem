class AddRejectedColumnToMeasurement < ActiveRecord::Migration[5.1]
  def change
    add_column :measurements, :rejected, :boolean, default: false
  end
end
