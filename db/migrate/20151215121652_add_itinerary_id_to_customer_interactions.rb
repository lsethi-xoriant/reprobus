class AddItineraryIdToCustomerInteractions < ActiveRecord::Migration
  def change
    add_column :customer_interactions, :itinerary_id, :integer
  end
end
