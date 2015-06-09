class AddLenghtToItiInfos < ActiveRecord::Migration
  def change
    add_column :itinerary_infos, :length, :integer
  end
end
