class AddNumberToXinvoice < ActiveRecord::Migration
  def change
    add_column :x_invoices, :invoice_number, :string
    add_column :x_invoices, :due_date, :date
    add_column :x_invoices, :status, :string
  end
end
