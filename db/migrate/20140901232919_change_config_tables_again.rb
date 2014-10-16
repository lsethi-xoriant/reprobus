class ChangeConfigTablesAgain < ActiveRecord::Migration
  def change
    drop_table :customers_destinations
    drop_table :customers_stopovers
    drop_table :customers_carriers
    
    create_table :destinations_enquiries, id: false do |t|
      t.integer :enquiry_id
      t.integer :destination_id
    end
    create_table :enquiries_stopovers, id: false do |t|
      t.integer :enquiry_id
      t.integer :stopover_id
    end
    create_table :carriers_enquiries, id: false do |t|
      t.integer :enquiry_id
      t.integer :carrier_id
    end    
  end
end
