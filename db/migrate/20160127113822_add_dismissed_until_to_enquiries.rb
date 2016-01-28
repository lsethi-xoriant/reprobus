class AddDismissedUntilToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :dismissed_until, :date
  end
end
