class AddAgentIdToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :agent_id, :integer
  end
end
