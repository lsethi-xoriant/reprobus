class AddAttachmentToCustomerInteractions < ActiveRecord::Migration
  def change
    add_column :customer_interactions, :attachment, :string
  end
end
