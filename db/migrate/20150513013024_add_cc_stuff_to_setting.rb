class AddCcStuffToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :cc_mastercard, :decimal, :precision => 5, :scale => 4
    add_column :settings, :cc_visa, :decimal, :precision => 5, :scale => 4
    add_column :settings, :cc_amex, :decimal, :precision => 5, :scale => 4
  end
end
 