class ChangeActivitiesTables < ActiveRecord::Migration
  def change
    rename_table :customer_activities, :customers_activities
    rename_table :user_activities, :users_activities
  end
end
