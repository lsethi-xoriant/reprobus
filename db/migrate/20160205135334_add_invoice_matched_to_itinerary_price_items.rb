class AddInvoiceMatchedToItineraryPriceItems < ActiveRecord::Migration
  def change
    add_column :itinerary_price_items, :invoice_matched, :boolean
  end
end
