class AddDepositToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :deposit, :integer
  end
end
