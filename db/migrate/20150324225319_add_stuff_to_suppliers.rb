class AddStuffToSuppliers < ActiveRecord::Migration
  def change
    add_column :customers, :num_days_payment_due, :integer
    add_column :customers, :after_hours_phone, :string, :limit => 32
  end
end
