class AddTemplateToItinerary < ActiveRecord::Migration
  def change
    add_column :itineraries, :itinerary_template_id, :integer
  end
end
