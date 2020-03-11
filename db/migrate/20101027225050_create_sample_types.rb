class CreateSampleTypes < ActiveRecord::Migration[4.2]
  def self.up
    create_table :sample_types do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :sample_types
  end
end
