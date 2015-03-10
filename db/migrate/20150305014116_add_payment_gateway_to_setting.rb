class AddPaymentGatewayToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :payment_gateway, :string
  end
end
