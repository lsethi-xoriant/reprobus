class AddRoomToItineraryInfoTemplate < ActiveRecord::Migration
  def change
    add_column  :itinerary_template_infos, :room_type, :integer
  end
end
