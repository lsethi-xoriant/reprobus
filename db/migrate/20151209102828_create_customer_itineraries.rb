class CreateCustomerItineraries < ActiveRecord::Migration
  def change
    create_table :customers_itineraries, id: false, force: :cascade do |t|
      t.integer :customer_id
      t.integer :itinerary_id
    end
  end
end
