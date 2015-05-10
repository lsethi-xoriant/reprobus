class AddSyncToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :receipt_sent, :boolean, :default => false
  end
end
