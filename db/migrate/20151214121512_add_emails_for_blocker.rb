class AddEmailsForBlocker < ActiveRecord::Migration
  def change
    add_column :settings, :overide_email_addresses , :text
    add_column :settings, :overide_emails , :boolean
  end
end
