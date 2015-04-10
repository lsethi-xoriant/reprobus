class AddXeroInvoiceDetailsToInvoice < ActiveRecord::Migration
  def change
    create_table :x_invoices do |t|
      t.decimal   :amount_due, :precision => 12, :scale => 5
      t.decimal   :amount_paid, :precision => 12, :scale => 5
      t.decimal   :total, :precision => 12, :scale => 5
      t.string    :currency_code
      t.string    :currency_rate
      t.date      :date
      t.string    :invoice_ref
      
      t.belongs_to :invoice
      t.timestamps
    end
  end
end
