class AddTimeToXinvoice < ActiveRecord::Migration
  def change
    add_column :x_invoices, :last_sync, :datetime
  end
end
