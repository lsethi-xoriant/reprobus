class AddIndexsToItinerary < ActiveRecord::Migration
  def change
    add_index :products, :hotel_id
    add_index :products, :cruise_id
  end
end
