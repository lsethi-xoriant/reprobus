class AddOffsetToInfoS < ActiveRecord::Migration
  def change
    add_column  :itinerary_infos, :offset, :integer, :default => 0
    add_column  :itinerary_template_infos, :offset, :integer, :default => 0
  end
end
