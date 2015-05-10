class AddIndexToInvoices < ActiveRecord::Migration
  def change
    add_index :invoices, :pxpay_balance_trxId
    add_index :invoices, :pxpay_deposit_trxId
  end
end
