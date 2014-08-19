class AddIndexToEmailReceiver < ActiveRecord::Migration
  def change
    add_index :email_receivers, :uniqueID
  end
end
