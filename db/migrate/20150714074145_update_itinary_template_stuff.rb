class UpdateItinaryTemplateStuff < ActiveRecord::Migration
  def change
     add_column :itinerary_templates, :type, :string
     add_column :itinerary_templates, :start_date, :date
     add_column :itinerary_templates, :end_date, :date
     
     add_column :itinerary_template_infos, :supplier_id, :integer
  end
end
