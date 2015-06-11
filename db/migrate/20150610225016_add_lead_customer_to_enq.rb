class AddLeadCustomerToEnq < ActiveRecord::Migration
  def change
    add_column :enquiries, :lead_customer_id, :integer
  end
end
