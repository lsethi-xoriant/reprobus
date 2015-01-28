class AddTypeToCustomer2 < ActiveRecord::Migration
  def change
    rename_column :customers, :type, :cust_sup

  end
end
