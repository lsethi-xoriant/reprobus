class AddUserNameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :user_email, :string    
  end
end
