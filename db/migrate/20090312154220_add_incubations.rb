class AddIncubations < ActiveRecord::Migration
  def self.up
    add_column :samples, :start_date, :date
  end

  def self.down
    remove_column :samples, :start_date
  end
end
