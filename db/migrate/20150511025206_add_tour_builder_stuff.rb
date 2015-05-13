class AddTourBuilderStuff < ActiveRecord::Migration
  def change

   create_table :itineraries do |t|
      t.string    :name
      t.date      :start_date
      t.integer   :num_passengers
      t.boolean   :complete
      t.boolean   :sent
      t.boolean   :quality_check
      t.decimal   :price_per_person, :precision => 12, :scale => 2
      t.decimal   :price_total, :precision => 12, :scale => 2
      t.string    :bed
      t.text      :includes
      t.text      :excludes
      t.text      :notes
      t.string    :flight_reference
      
      t.belongs_to :user, index:true
      t.belongs_to :customer, index:true
      t.timestamps
    end
    
    create_table :products do |t|
      t.string    :type
      t.string    :name
      t.string    :country
      t.string    :city
      t.string    :description
      t.decimal   :price_single, :precision => 12, :scale => 2
      t.decimal   :price_double, :precision => 12, :scale => 2
      t.decimal   :price_tripple, :precision => 12, :scale => 2
      t.string    :product_type
      t.string    :room_type
      t.string    :rating
      t.string    :destination
      t.integer   :default_length
      t.integer   :supplier_id, index:true
      
      t.timestamps
    end
    
   create_table :itinerary_infos do |t|
      t.string    :name
      t.date      :start_date
      t.date      :end_date
      t.string    :country
      t.string    :city
      t.string    :product_type
      t.string    :product_name
      t.string    :product_description
      t.string    :product_price
      t.string    :rating
      t.string    :room_type
      t.decimal   :price_per_person, :precision => 12, :scale => 2
      t.decimal   :price_total, :precision => 12, :scale => 2
      t.integer   :position
      t.integer   :supplier_id, index:true
      
      t.belongs_to :itinerary, index:true
      t.belongs_to :product, index:true
      t.timestamps
    end
    
    create_table :itinerary_templates do |t|
      t.string    :name
      t.text      :includes
      t.text      :excludes
      t.text      :notes
      t.timestamps
    end

    create_table :itinerary_template_infos do |t|
      t.integer    :position
      t.integer    :length
      t.integer    :days_from_start
      
      t.belongs_to  :product, index:true
      t.belongs_to :itinerary_template, index:true
      t.timestamps
    end
    
    create_table :itinerary_prices do |t|
      t.belongs_to :itinerary, index:true
      t.timestamps
    end
    
    create_table :itinerary_price_items do |t|
      t.string    :booking_ref
      t.string    :description
      t.decimal   :price_total, :precision => 12, :scale => 2
      t.integer   :supplier_id, index:true
      
      t.belongs_to :itinerary_price, index:true
      t.timestamps
    end
  end
end
