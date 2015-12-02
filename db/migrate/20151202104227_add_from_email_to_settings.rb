class AddFromEmailToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :itineraries_from_email, :string
  end
end
