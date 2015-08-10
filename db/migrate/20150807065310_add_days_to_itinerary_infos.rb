class AddDaysToItineraryInfos < ActiveRecord::Migration
  def change
    add_column :itinerary_infos, :days_from_start, :integer
  end
end
