class CreateSupplierInvoices < ActiveRecord::Migration
  def change
    change_table :invoices do |t|
      t.integer  "supplier_invoice_id"
    end  
  end
end
