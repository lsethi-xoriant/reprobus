class ChangeMobileToAltPhoneCustomer < ActiveRecord::Migration
  def change
    rename_column :customers, :mobile, :alt_phone
  end
end
