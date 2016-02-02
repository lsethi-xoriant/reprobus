class RemoveDestinationIdFromEnquiries < ActiveRecord::Migration
  def change
    remove_column :enquiries, :destination_id, :integer
  end
end
