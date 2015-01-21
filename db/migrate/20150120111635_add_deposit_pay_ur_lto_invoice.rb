class AddDepositPayUrLtoInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :depositPayUrl, :string
  end
end
