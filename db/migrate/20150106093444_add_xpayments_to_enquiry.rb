class AddXpaymentsToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :xpayments, :text
  end
end
