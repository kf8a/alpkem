class MoveStartDate < ActiveRecord::Migration[4.2]
  def self.up
    add_column :runs, :start_date, :date
    remove_column :samples, :start_date
  end

  def self.down
    add_column :samples, :start_date, :date
    remove_column :runs, :start_date
  end
end
