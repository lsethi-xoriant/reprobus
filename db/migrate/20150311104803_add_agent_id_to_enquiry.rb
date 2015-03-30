class AddAgentIdToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :agent_id, :integer
  end
end
