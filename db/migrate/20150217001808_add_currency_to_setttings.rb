class AddCurrencyToSetttings < ActiveRecord::Migration
  def change
    add_column :settings, :currency_id, :integer
  end
end
