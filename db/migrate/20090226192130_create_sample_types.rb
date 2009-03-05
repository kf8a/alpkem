class CreateSampleTypes < ActiveRecord::Migration
  def self.up
    create_table :sample_types do |t|
      t.string :name
      t.string :regular_expression
    end
    
    SampleType.reset_column_information
    SampleType.create({:name => 'Lysimeter', 
        :regular_expression => '\\t(.{1,2})-(.)([A-C|a-c])( rerun)*\\t\\s+-*\\d+\\.\\d+\\s+(-*\\d\\.\\d+)\\t.*\\t *-*\\d+\\.\\d+\\s+(-*\\d+\\.\\d+)\t'})
    SampleType.create({:name => 'Soil Sample',
        :regular_expression => '\t\d{3}\t(\w{1,2})-(\d)[abc|ABC]( rerun)*\t\s+-*\d+\.\d+\s+(-*\d\.\d+)\t.*\t *-*\d+\.\d+\s+(-*\d+\.\d+)\t'})
  end

  def self.down
    drop_table :sample_types
  end
end
