class CreateTreatments < ActiveRecord::Migration[4.2]
  def self.up
    create_table :treatments do |t|
      t.string :name
      t.integer :study_id
    end
    add_index :treatments, :name
  end

  def self.down
    drop_table :treatments
  end
end
