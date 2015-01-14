class Addxerotobooking < ActiveRecord::Migration
  def change
    add_column :bookings, :xpayments, :text
    add_column :bookings, :xero_id, :string
    add_column :bookings, :xdeposits, :text
  end
end
