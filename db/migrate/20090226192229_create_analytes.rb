class CreateAnalytes < ActiveRecord::Migration[4.2]
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
