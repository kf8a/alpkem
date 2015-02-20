class AddRejectedColumnToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :rejected, :boolean, default: false
  end
end
