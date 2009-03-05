class CreateAnalytes < ActiveRecord::Migration
  def self.up
    create_table :analytes do |t|
      t.string :name
      t.string :unit
    end
    Analyte.reset_column_information
    Analyte.new({:name => 'NO3', :unit => 'ppm'}).save
    Analyte.new({:name => 'NH4', :unit => 'ppm'}).save
    
  end

  def self.down
    drop_table :analytes
  end
end
