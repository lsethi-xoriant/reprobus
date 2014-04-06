class CreateCustomerEnquiries < ActiveRecord::Migration
  def change
    create_table :customer_enquiries do |t|
      t.integer  "customer_id"
      t.integer  "enquiry_id"
      
      t.string   "role",           :limit => 32
      t.timestamps
    end
  end
end
