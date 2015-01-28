class AddSuppNameToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :supplier_name, :string
  end
end
