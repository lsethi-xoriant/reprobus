class AddBeedingTypeToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :bedding_type, :integer
  end
end
