class AddCruyiseDaysToProduct < ActiveRecord::Migration
  def change
    add_column :products, :cruise_id, :integer
  end
end
