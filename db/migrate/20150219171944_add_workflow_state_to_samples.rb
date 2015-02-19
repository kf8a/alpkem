class AddWorkflowStateToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :workflow_state, :string
  end
end
