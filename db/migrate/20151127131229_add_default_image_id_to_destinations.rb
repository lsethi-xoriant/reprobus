class AddDefaultImageIdToDestinations < ActiveRecord::Migration
  def change
    add_column :destinations, :default_image_id, :integer
  end
end
