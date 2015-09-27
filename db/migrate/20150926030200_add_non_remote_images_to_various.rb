class AddNonRemoteImagesToVarious < ActiveRecord::Migration
  
    create_table :image_holders do |t|
      t.string    :image_local
      t.string   :image_remote_url
      t.belongs_to :setting
      t.belongs_to :itinerary
      t.belongs_to :itinerary_template
      t.timestamps
    end

  def change
    remove_column :settings, :itinerary_default_image, :string
    remove_column :settings, :company_logo, :string
    remove_column :itineraries, :itinerary_default_image, :string
    remove_column :itinerary_templates, :itinerary_default_image, :string
    
    
    add_column :settings, :itinerary_default_image_id, :integer
    add_column :settings, :company_logo_id, :integer
    add_column :itineraries, :itinerary_default_image_id, :integer
    add_column :itinerary_templates, :itinerary_default_image_id, :integer    
  end    
    
    
end
