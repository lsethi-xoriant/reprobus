class AddEndDateToItineraries < ActiveRecord::Migration
  def change
    add_column :itineraries, :end_date, :date
  end
end
