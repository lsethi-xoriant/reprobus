class AddPdfImagesToVarious < ActiveRecord::Migration
  def change
    add_column :settings, :itinerary_default_image, :string
    add_column :settings, :company_logo, :string
    add_column :itineraries, :itinerary_default_image, :string
    add_column :itinerary_templates, :itinerary_default_image, :string
  end
end
