class AddMoreToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :reference, :text
    add_column :payments, :date, :date
  end
end
