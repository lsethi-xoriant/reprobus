class AddDummySupplierToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :dummy_supplier, :boolean
  end
end
