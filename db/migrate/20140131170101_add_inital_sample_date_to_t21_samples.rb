class AddInitalSampleDateToT21Samples < ActiveRecord::Migration[4.2]
  def change
    add_column :runs, :initial_sample_date, :date
  end
end
