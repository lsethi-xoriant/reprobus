class AddFromEmailToSettings < ActiveRecord::Migration
  def change
    add_column :itineraries, :itineraries_from_email, :string
  end
end
