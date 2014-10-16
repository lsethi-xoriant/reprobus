class ChangeConfigTablesName < ActiveRecord::Migration
  def change
    rename_table :customer_destinations, :customers_destinations
    rename_table :customer_carriers, :customers_carriers
    rename_table :customer_stopovers, :customers_stopovers
  end
end
