class CreateCnSamples < ActiveRecord::Migration[4.2]
  def self.up
    create_table :cn_samples do |t|
      t.string   "cn_plot"
      t.date     "sample_date"
      t.boolean  "approved",       :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cn_samples
  end
end
