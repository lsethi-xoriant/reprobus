class ChangePayUrlToInv < ActiveRecord::Migration
  def change
    rename_column :invoices, :depositPayUrl, :pxpay_deposit_trxId
    rename_column :invoices, :balancePayUrl, :pxpay_balance_trxId
  end
end
