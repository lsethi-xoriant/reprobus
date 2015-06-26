class AddRoomToProducts < ActiveRecord::Migration
  def change
    remove_column :job_progresses, :file_path
    remove_column :job_progresses, :file_name
    remove_column :products, :product_type
    rename_column :products, :price_tripple, :price_triple
    
    
    add_column :products, :hotel_id, :integer
    add_column :products, :address, :text
    add_column :products, :phone, :string
  end
end
