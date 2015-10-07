class AddMealsAndClassToItineraryTemp < ActiveRecord::Migration
  def change
    add_column :itinerary_template_infos, :includes_breakfast, :boolean
    add_column :itinerary_template_infos, :includes_lunch, :boolean
    add_column :itinerary_template_infos, :includes_dinner, :boolean    
    add_column :itinerary_template_infos, :group_classification, :string    
  end
end
