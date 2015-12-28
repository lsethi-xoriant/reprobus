class AddFieldsToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :public_edit_token,        :string
    add_column :customers, :public_edit_token_expiry, :date
    add_column :customers, :frequent_flyer_details,   :text
    add_column :customers, :emergency_contact,        :string
    add_column :customers, :emergency_contact_phone,  :string
    add_column :customers, :dietary_requirements,     :text
    add_column :customers, :medical_information,      :text
  end
end
