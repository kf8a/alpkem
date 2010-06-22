class DeleteSampleType < ActiveRecord::Migration
  def self.up
     drop_table :sample_types
  end

  def self.down
    create_table "sample_types", :force => true do |t|
      t.string "name"
      t.string "regular_expression"
    end
  end
end
