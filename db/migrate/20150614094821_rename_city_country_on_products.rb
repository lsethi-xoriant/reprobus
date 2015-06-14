class RenameCityCountryOnProducts < ActiveRecord::Migration
  def change
    rename_column :products, :city, :destination_search
    rename_column :products, :country, :country_search
  end
end
