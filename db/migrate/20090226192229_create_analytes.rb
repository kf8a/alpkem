class CreateAnalytes < ActiveRecord::Migration
  def self.up
    create_table :analytes do |t|
      t.string :name
      t.string :unit
    end
  end

  def self.down
    drop_table :analytes
  end
end
