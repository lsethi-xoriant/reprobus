class AddMarkupanddepositToPriceitems < ActiveRecord::Migration
  def change
    rename_column :itinerary_price_items, :deposit, :deposit_percentage
    add_column :itinerary_price_items, :deposit, :decimal,:precision => 12, :scale => 2, :default => 0.00
    add_column :itinerary_price_items, :markup, :decimal,:precision => 12, :scale => 2, :default => 0.00
    
  end
end
