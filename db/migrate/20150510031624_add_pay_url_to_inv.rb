class AddPayUrlToInv < ActiveRecord::Migration
  def change
    add_column :invoices, :balancePayUrl, :string
  end
end
