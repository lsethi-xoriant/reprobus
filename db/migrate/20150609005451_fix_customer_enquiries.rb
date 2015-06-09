class FixCustomerEnquiries < ActiveRecord::Migration
  def change
    rename_table :customer_enquiries, :customers_enquiries
    remove_column :customers_enquiries, :role
    
    add_index :customers_enquiries, :customer_id
    add_index :customers_enquiries, :enquiry_id
  end
end
