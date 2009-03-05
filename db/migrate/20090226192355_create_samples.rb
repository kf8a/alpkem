class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.integer :plot_id
      t.integer :sample_type_id
      t.date :sample_date
      t.boolean :approved, :default => false
      t.timestamps
    end
    
    add_index :samples, :plot_id
    add_index :samples, :sample_date
  end

  def self.down
    drop_table :samples
  end
end
