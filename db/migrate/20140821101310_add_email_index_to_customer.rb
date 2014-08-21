class AddEmailIndexToCustomer < ActiveRecord::Migration
  def change
    add_index :customers, :emailID
  end
end
