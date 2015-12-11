class AddDestinationIdToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :destination_id, :integer
  end
end
