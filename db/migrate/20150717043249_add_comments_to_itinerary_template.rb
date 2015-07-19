class AddCommentsToItineraryTemplate < ActiveRecord::Migration
  def change
    add_column :itinerary_infos, :comment_for_supplier, :text
    add_column :itinerary_infos, :comment_for_customer, :text
  end
end
