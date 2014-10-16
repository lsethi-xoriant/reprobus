class TidyEnquiryAttribs < ActiveRecord::Migration
  def change
    remove_column :enquiries, :carriers
    remove_column :enquiries, :stopovers
    remove_column :enquiries, :destinations
  end
end
