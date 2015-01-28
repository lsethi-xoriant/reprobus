class AddXeroIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :xero_id, :string
    add_column :invoices, :xdeposits, :text
    add_column :invoices, :xpayments, :text
  end
end
