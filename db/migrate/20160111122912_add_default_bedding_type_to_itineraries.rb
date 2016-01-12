class AddDefaultBeddingTypeToItineraries < ActiveRecord::Migration
  def up
    change_column :itineraries, :bedding_type, :integer, default: 0
    Itinerary.where(bedding_type: nil).update_all(bedding_type: 0)
  end

  def down
    change_column :itineraries, :bedding_type, :integer, default: nil
  end
end
