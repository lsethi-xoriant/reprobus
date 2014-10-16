class ChangeConfigTablesNoId < ActiveRecord::Migration
  def change
    drop_table :customers_destinations
    drop_table :customers_stopovers
    drop_table :customers_carriers
    
    create_table :customers_destinations, id: false do |t|
      t.integer :customer_id
      t.integer :destination_id
    end
    create_table :customers_stopovers, id: false do |t|
      t.integer :customer_id
      t.integer :stopover_id
    end
    create_table :customers_carriers, id: false do |t|
      t.integer :customer_id
      t.integer :carrier_id
    end    
  end
end
