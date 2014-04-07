class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|

      t.string :street1
      t.string :street2
      t.string :city,    :limit => 64
      t.string :state,   :limit => 64
      t.string :zipcode, :limit => 16
      t.string :country, :limit => 64
      t.string :full_address
      t.string :address_type, :limit => 16

      t.references :addressable, :polymorphic => true

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :addresses, [ :addressable_id, :addressable_type ]    
  end
end
