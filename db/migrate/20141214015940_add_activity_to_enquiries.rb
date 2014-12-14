class AddActivityToEnquiries < ActiveRecord::Migration
  create_table :enquiries_activities do |t|
    t.belongs_to :activity 
    t.belongs_to :enquiry
    t.timestamps
  end
  
  def change
    add_column :activities, :enquiry_id, :integer        
  end
end
