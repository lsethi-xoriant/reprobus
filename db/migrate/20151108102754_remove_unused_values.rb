class RemoveUnusedValues < ActiveRecord::Migration
  def change
    remove_column :itinerary_infos, :product_description
    remove_column :itinerary_infos, :product_name
    remove_column :itinerary_infos, :product_price
    remove_column :itinerary_infos, :product_type
    remove_column :itinerary_infos, :country
    remove_column :itinerary_infos, :city
    remove_column :itinerary_infos, :name
    remove_column :itinerary_infos, :rating
    remove_column :itinerary_infos, :price_total
    remove_column :itinerary_infos, :price_per_person
    remove_column :itinerary_infos, :days_from_start
    remove_column :itinerary_infos, :offset

    remove_column :itinerary_template_infos, :offset
    
    remove_column :itineraries, :bed
    remove_column :itineraries, :price_per_person
    remove_column :itineraries, :price_total
    

  end
end
