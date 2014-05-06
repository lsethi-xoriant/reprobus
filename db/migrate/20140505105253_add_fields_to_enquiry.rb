class AddFieldsToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :fin_date, :date
    
    add_column :enquiries, :standard, :string
    add_column :enquiries, :insurance, :boolean
    add_column :enquiries, :reminder, :date
    add_column :enquiries, :destinations, :text
    add_column :enquiries, :stopovers, :text
    add_column :enquiries, :carriers, :text
    
    change_column :enquiries, :probability, :string
    
    create_table :products do |t|
      t.string :name
      t.text :description
 
      t.timestamps
    end    
  end
end
