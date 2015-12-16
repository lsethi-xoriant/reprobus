class FixInvoicePriceItems < ActiveRecord::Migration
  def change
    remove_column :invoices, :customer_itinerary_price_id
    remove_column :invoices, :supplier_itinerary_price_id
    add_column :invoices, :itinerary_price_id , :integer
  end
end
