class AddexchangeratetoInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :exchange_rate, :decimal, :precision => 12, :scale => 2
  end
end
