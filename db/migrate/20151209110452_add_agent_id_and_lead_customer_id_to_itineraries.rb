class AddAgentIdAndLeadCustomerIdToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :agent_id, :integer
    add_column :itineraries, :lead_customer_id, :integer
  end
end
