class AddCountryIdToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :country_id, :integer
  end
end
