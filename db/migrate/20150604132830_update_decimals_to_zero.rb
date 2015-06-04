class UpdateDecimalsToZero < ActiveRecord::Migration
  def change
    change_column :enquiries, :amount, :decimal, :precision => 12, :scale => 2, :null => false, :default => 0.00
    change_column :enquiries, :discount, :decimal, :precision => 12, :scale => 2, :null => false, :default => 0.00
    
    change_column :payments, :amount, :decimal, :precision => 12, :scale => 5, :default => 0.00
    change_column :x_invoices, :amount_due, :decimal, :precision => 12, :scale => 5, :default => 0.00
    change_column :x_invoices, :amount_paid, :decimal, :precision => 12, :scale => 5, :default => 0.00
    change_column :x_invoices, :total, :decimal, :precision => 12, :scale => 5, :default => 0.00
    
    change_column :itinerary_price_items, :price_total, :decimal, :precision => 12, :scale => 2, :default => 0.00
    
    change_column :invoices, :exchange_amount, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :invoices, :exchange_rate, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :invoices, :deposit, :decimal, :precision => 12, :scale => 2, :default => 0.00


    change_column :line_items, :item_price, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :line_items, :total, :decimal, :precision => 12, :scale => 2, :default => 0.00
    
    change_column :bookings, :deposit, :decimal, :precision => 12, :scale => 2, :default => 0.00
    change_column :bookings, :amount, :decimal, :precision => 12, :scale => 2, :default => 0.00
    
    
    Enquiry.where("amount = ?", nil).update_all(amount: 0.00)
  end
end
