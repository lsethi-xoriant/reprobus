class AddTurnoffemailsToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :send_emails_turned_off, :boolean
  end
end
