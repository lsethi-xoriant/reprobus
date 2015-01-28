class AddTypeToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :type, :string
  end
end
