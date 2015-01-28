class AddSuppIdToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :supplier_id, :integer
  end
end
