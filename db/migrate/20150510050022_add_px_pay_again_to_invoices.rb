class AddPxPayAgainToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :pxpay_deposit_url, :string
    add_column :invoices, :pxpay_balance_url, :string
  end
end
