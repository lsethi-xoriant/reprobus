class AddCustomerNamesToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :customer_names, :text
  end
end
