class CreateEmailTemplates < ActiveRecord::Migration
  def change
    
    create_table :triggers do |t|
      t.string    :name
      t.integer   :num_days
      t.belongs_to :setting
      t.timestamps
    end
    
    create_table :email_templates do |t|
      t.string    :name
      t.string    :from_email
      t.string    :from_name
      t.string    :subject
      t.string    :body
      t.string    :from_email
      t.boolean   :copy_assigned_user
      t.belongs_to :trigger
      t.timestamps
    end
  end
end
