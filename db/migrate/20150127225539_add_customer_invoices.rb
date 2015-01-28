class AddCustomerInvoices < ActiveRecord::Migration
  def change
      change_table :invoices do |t|
      t.integer  "customer_invoice_id"
      t.string   "currency"
    end  
  end
end
