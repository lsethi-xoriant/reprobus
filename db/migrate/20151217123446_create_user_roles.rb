class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.integer :role_id
    end
    add_index :user_roles, [:user_id, :role_id], unique: true
  end
end
