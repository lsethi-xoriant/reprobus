class AddMoreInfoToPricingItems < ActiveRecord::Migration
  def change
    add_column :invoices, :customer_itinerary_price_id, :integer
    add_column :invoices, :supplier_itinerary_price_id, :integer
    
    add_column :itinerary_price_items, :supplier_itinerary_price_id, :integer
    add_column :itinerary_price_items, :invoice_id, :integer
    
    add_column :itinerary_price_items, :quantity, :integer, :default => 0
    add_column :itinerary_price_items, :item_price, :decimal,:precision => 12, :scale => 2, :default => 0.00
    add_column :itinerary_price_items, :deposit, :integer, :default => 0
  end
end
