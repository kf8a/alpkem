class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :name
      t.string :prefix
    end
  end

  def self.down
    drop_table :studies
  end
end
