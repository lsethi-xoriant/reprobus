class CreateEmailReceivers < ActiveRecord::Migration
  def change
    create_table :email_receivers do |t|
      t.string :uniqueID
      t.belongs_to :customer
      t.timestamps
    end
  end
end
