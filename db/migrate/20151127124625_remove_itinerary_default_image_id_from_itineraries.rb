class RemoveItineraryDefaultImageIdFromItineraries < ActiveRecord::Migration
  def change
    remove_column :itineraries, :itinerary_default_image_id
  end
end
