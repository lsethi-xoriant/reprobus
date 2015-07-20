class ChangeRoomTypeOnInfo < ActiveRecord::Migration
  def change
    remove_column  :itinerary_infos, :room_type
    add_column  :itinerary_infos, :room_type, :integer
  end
end
