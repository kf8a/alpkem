class CreateStudies < ActiveRecord::Migration
  def self.up
    create_table :studies do |t|
      t.string :name
      t.string :prefix
    end
    Study.reset_column_information
    Study.create({:name => 'Main Site', :prefix => 'T'})
    Study.create({:name => 'glbrc', :prefix => 'G'})
  end

  def self.down
    drop_table :studies
  end
end
