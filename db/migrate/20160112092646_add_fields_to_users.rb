class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_image_id, :integer
    add_column :users, :phone, :string
    add_column :users, :profile_description, :text
  end
end
