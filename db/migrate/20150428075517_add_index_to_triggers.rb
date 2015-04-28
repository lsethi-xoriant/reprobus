class AddIndexToTriggers < ActiveRecord::Migration
  def change
    add_index :triggers, :email_template_id
    add_index :triggers, :name
    add_index :triggers, :setting_id
  end
end
