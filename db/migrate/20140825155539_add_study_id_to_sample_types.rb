class AddStudyIdToSampleTypes < ActiveRecord::Migration
  def change
    add_column :sample_types, :study_id, :integer
  end
end
