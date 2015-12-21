class CustomerInvoiceSent < ActiveRecord::Migration
  def change
    add_column :itinerary_prices, :customer_invoice_sent_date , :date
    add_column :itinerary_prices, :customer_invoice_sent , :boolean    
  end
end
