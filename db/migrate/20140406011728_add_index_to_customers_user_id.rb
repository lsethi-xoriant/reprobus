class AddIndexToCustomersUserId < ActiveRecord::Migration
  def change
    add_index :customers, ["assigned_to"]
  end
end
