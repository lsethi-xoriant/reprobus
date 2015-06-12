class AddLeadCustomerForSearch < ActiveRecord::Migration
  def change
    add_column :enquiries, :lead_customer_name, :string
  end
end
