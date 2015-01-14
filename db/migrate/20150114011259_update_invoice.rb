class UpdateInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :deposit, :decimal, :precision => 12, :scale => 2
  end
end
