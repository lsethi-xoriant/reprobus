class AddCountriesToDestinations < ActiveRecord::Migration
  def change
    add_column :destinations, :country_id, :integer
  end
end
