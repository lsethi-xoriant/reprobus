class Addsupplieritems < ActiveRecord::Migration
  def change
    add_column :itinerary_price_items, :exchange_rate_total , :decimal,:precision => 12, :scale => 2, :default => 0.00
    add_column :itinerary_price_items, :total_incl_markup, :decimal,:precision => 12, :scale => 2, :default => 0.00
  end
end
