class FixInvoicePriceItems2 < ActiveRecord::Migration
  def change
    remove_column :invoices, :itinerary_price_id
  end
end
