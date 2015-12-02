class AddSentFieldsToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :quote_sent, :timestamp
    add_column :itineraries, :confirmed_itinerary_sent, :timestamp
  end
end
