class AddEnquiryToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :enquiry_id, :integer
    add_index :itineraries, :enquiry_id
    add_index :itineraries, :itinerary_template_id
  end
end
