class AddCurrencyToPricing < ActiveRecord::Migration
  def change
    add_column :itinerary_prices, :currency_id, :integer
  end
end
