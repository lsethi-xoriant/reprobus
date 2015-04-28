class AddSystemTriggersAgain < ActiveRecord::Migration
  def change
    remove_column :email_templates, :trigger_id
    add_column :triggers, :email_template_id, :integer
  end
end
