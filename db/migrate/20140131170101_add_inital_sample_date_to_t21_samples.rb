class AddInitalSampleDateToT21Samples < ActiveRecord::Migration
  def change
    add_column :runs, :initial_sample_date, :date
  end
end
