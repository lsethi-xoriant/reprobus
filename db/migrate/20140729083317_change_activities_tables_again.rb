class ChangeActivitiesTablesAgain < ActiveRecord::Migration
  def change
    add_column :activities, :customer_id, :integer    
    add_column :activities, :user_id, :integer    
  end
end
