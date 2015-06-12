class AddStatusToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :status, :string
  end
end
