class AddCountriesAdmin < ActiveRecord::Migration
  def change
    
    create_table :countries do |t|
      t.string :name
      t.timestamps
    end    
       
    add_column :products, :country_id, :integer
    add_column :products, :destination_id, :integer
  end
end
