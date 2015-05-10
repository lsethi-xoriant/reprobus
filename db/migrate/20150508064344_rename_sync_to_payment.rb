class RenameSyncToPayment < ActiveRecord::Migration
  def change
    rename_column :payments, :receipt_sent, :receipt_triggered
  end
end
