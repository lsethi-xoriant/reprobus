class AddPercentageToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :percent, :integer
  end
end
