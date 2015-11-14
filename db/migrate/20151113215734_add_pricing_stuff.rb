class AddPricingStuff < ActiveRecord::Migration
  def change
    add_column :itinerary_prices, :deposit, :decimal,:precision => 12, :scale => 2, :default => 0.00
    add_column :itinerary_prices, :sale_total, :decimal,:precision => 12, :scale => 2, :default => 0.00
    add_column :itinerary_prices, :deposit_system_default, :boolean, :default => false
  end
end
