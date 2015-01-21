class AddCreditCardPaymentsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :ccPaymentsAmount, :text
    add_column :invoices, :ccPaymentsDate, :text
  end
end
