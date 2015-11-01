class AddQuoteAndItineraryBlurbToSettings < ActiveRecord::Migration
  def change
      add_column :settings, :quote_introduction, :text
      add_column :settings, :confirmed_introduction, :text
  end
end
