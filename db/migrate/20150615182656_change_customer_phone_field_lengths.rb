class ChangeCustomerPhoneFieldLengths < ActiveRecord::Migration
  def change
    change_column :customers, :phone, :string, :limit => 255
    change_column :customers, :after_hours_phone, :string, :limit => 255
    change_column :addresses, :street1, :text
    change_column :addresses, :street2, :text

  end
end
