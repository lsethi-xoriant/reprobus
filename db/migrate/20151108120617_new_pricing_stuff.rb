class NewPricingStuff < ActiveRecord::Migration
  def change
    add_column :itinerary_prices, :deposit_due, :date
    add_column :itinerary_prices, :invoice_date, :date
    add_column :itinerary_prices, :balance_due, :date
    add_column :itinerary_prices, :final_balance_due, :date
  end
end
