class AddExchangeCurrToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :exchange_amount, :decimal, :precision => 12, :scale => 2
  end
end
