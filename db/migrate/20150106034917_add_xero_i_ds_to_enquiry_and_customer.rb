class AddXeroIDsToEnquiryAndCustomer < ActiveRecord::Migration
  def change
    add_column :enquiries, :xero_id, :string
    add_column :customers, :xero_id, :string 
  end
end
