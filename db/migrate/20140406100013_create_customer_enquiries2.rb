class CreateCustomerEnquiries2 < ActiveRecord::Migration
  def change
    create_table :customer_enquiries do |t|
      t.references :customer
      t.references :enquiry
      t.string     :role, :limit => 32
      t.datetime   :deleted_at      

      t.timestamps
    end
  end
end
