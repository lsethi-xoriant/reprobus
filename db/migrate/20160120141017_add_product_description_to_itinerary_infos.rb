class AddProductDescriptionToItineraryInfos < ActiveRecord::Migration
  def change
    add_column :itinerary_infos, :product_description, :text
  end
end
