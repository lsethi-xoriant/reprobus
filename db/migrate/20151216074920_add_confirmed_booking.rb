class AddConfirmedBooking < ActiveRecord::Migration
  def change
    add_column :itinerary_prices, :booking_confirmed_date , :date
    add_column :itinerary_prices, :booking_confirmed , :boolean
  end
end
