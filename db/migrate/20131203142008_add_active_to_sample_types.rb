class AddActiveToSampleTypes < ActiveRecord::Migration
  def change
    add_column :sample_types, :active, :boolean, default: true
    add_column :sample_types, :parser, :text
  end
end
