class ChangesToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :cc_payment, :boolean, :default => false
    add_column :payments, :cc_payment_ref, :string
    add_column :payments, :cc_client_info, :string
  end
end
