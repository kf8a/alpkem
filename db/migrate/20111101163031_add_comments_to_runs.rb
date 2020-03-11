class AddCommentsToRuns < ActiveRecord::Migration[4.2]
  def self.up
    add_column :runs, :comment, :text
  end

  def self.down
    remove_column :runs, :comment
  end
end
