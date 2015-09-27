class RemoveNonRemoteImagesToVarious < ActiveRecord::Migration
  def change
    remove_column :image_holders, :setting_id
    remove_column :image_holders, :itinerary_id
    remove_column :image_holders, :itinerary_template_id
  end
end
