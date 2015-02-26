class AddCurrencyExchange < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.decimal   :exchange_rate, :precision => 12, :scale => 5
      t.string    :currency_code
      t.belongs_to :setting
      t.timestamps
    end
  end
end
