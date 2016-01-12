class AddPaymentsToIp < ActiveRecord::Migration
  def change
    add_column :settings, :pin_payment_url, :string
    add_column :settings, :base_url, :string
    add_column :payments, :payment_type, :string
    add_column :payments, :itinerary_price_id, :integer
  end
end
