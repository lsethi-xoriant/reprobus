class AddWhoRequestedUpdateUserIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :who_requested_update_user_id, :integer
  end
end
