class AddUniqueIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :emailID, :string
  end
end
