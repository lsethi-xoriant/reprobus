class AddDueDateConfigToEttings < ActiveRecord::Migration
  def change
    add_column :settings, :num_days_balance_due, :integer, :default => 95
    add_column :settings, :num_days_deposit_due, :integer, :default => 7
    add_column :settings, :deposit_percentage, :integer, :default => 0
    add_column :customers, :agent_commision_percentage, :integer, :default => 0
    add_column :itinerary_price_items, :start_date, :date
    add_column :itinerary_price_items, :currency_id, :integer
    add_column :itinerary_price_items, :markup_percentage, :integer
    add_column :itinerary_price_items, :end_date, :date 
    add_column :itinerary_prices, :locked, :boolean, :default => false
    add_column :itinerary_price_items, :sell_currency_rate, :decimal,:precision => 12, :scale => 2, :default => 0.00
  end
end
