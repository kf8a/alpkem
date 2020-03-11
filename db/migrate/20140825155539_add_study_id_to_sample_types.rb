class AddStudyIdToSampleTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :sample_types, :study_id, :integer
  end
end
