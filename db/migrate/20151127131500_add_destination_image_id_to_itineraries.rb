class AddDestinationImageIdToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :destination_image_id, :integer
  end
end
