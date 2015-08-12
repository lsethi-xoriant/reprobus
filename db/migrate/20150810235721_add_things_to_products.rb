class AddThingsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :group_classification, :string
    add_column :products, :includes_breakfast, :boolean
    add_column :products, :includes_lunch, :boolean
    add_column :products, :includes_dinner, :boolean
    
    add_column :settings, :itinerary_includes, :text
    add_column :settings, :itinerary_excludes, :text
    add_column :settings, :itinerary_notes, :text
    
    add_column :itinerary_infos, :includes_breakfast, :boolean
    add_column :itinerary_infos, :includes_lunch, :boolean
    add_column :itinerary_infos, :includes_dinner, :boolean    
    add_column :itinerary_infos, :group_classification, :string
  end
end
