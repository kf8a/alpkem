class AddIncubations < ActiveRecord::Migration[4.2]
  def self.up
    add_column :samples, :start_date, :date
  end

  def self.down
    remove_column :samples, :start_date
  end
end
