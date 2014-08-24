class RemoveEmailReceiver < ActiveRecord::Migration
  def up
    drop_table :email_receivers
  end
  
  def down
    create_table :email_receivers do |t|
      t.string :uniqueID
      t.belongs_to :customer
      t.timestamps
    end
  end
end
