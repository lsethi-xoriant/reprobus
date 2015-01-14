class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.belongs_to :customer
      t.belongs_to :enquiry
      t.belongs_to :user
      t.decimal  "amount",   :precision => 12, :scale => 2
      t.decimal  "deposit",   :precision => 12, :scale => 2
      t.string :name
      t.string :status
      t.timestamps
    end
  end
end
