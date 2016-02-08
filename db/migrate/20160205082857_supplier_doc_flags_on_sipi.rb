class SupplierDocFlagsOnSipi < ActiveRecord::Migration
  def change
    add_column :itinerary_price_items, :supplier_quote_sent, :boolean
    add_column :itinerary_price_items, :supplier_request_sent, :boolean
    add_column :itinerary_price_items, :supplier_check_sent, :boolean
    add_column :itinerary_price_items, :supplier_invoice_matched, :boolean
  end
end
