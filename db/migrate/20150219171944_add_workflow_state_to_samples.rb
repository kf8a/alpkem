class AddWorkflowStateToSamples < ActiveRecord::Migration[5.1]
  def change
    add_column :samples, :workflow_state, :string
  end
end
