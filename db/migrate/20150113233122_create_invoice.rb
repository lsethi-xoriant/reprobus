class CreateInvoice < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :booking
      t.string :status
      t.datetime  :invoice_date 
      t.datetime  :deposit_due 
      t.datetime  :final_payment_due 
      t.timestamps
    end
    
    create_table :line_items do |t|
      t.belongs_to :invoice
      t.decimal  :item_price,   :precision => 12, :scale => 2
      t.decimal  :total,   :precision => 12, :scale => 2
      t.string :description
      t.integer :quantity
      t.timestamps
    end    
  end
end
