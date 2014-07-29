class AddSettings < ActiveRecord::Migration
  #NOTE THESE TABLES ARE NAMED WRONG - SHOULD BE CUSTOMERS_XXXX
  
  def change    
    drop_table :products
    
    create_table :destination do |t|
      t.string :name
      t.timestamps
    end    
    
    create_table :customer_destinations do |t|
      t.belongs_to :customer
      t.belongs_to :destination
      t.timestamps
    end    
    
    create_table :carrier do |t|
      t.string :name
      t.timestamps
    end    
    
    create_table :customer_carriers do |t|
      t.belongs_to :customer
      t.belongs_to :carrier
      t.timestamps
    end        
    
    create_table :stopover do |t|
      t.string :name
      t.timestamps
    end     
    
    create_table :customer_stopovers do |t|
      t.belongs_to :customer
      t.belongs_to :stopover
      t.timestamps
    end     
    
  end
end
