class AddFieldsToEnquiries < ActiveRecord::Migration
  def change
  add_column :enquiries, :duration, :string
  add_column :enquiries, :est_date, :date
  add_column :enquiries, :num_people, :string
  
  end
end
