# == Schema Information
#
# Table name: itinerary_infos
#
#  id                   :integer          not null, primary key
#  name                 :string
#  start_date           :date
#  end_date             :date
#  country              :string
#  city                 :string
#  product_type         :string
#  product_name         :string
#  product_description  :string
#  product_price        :string
#  rating               :string
#  price_per_person     :decimal(12, 2)
#  price_total          :decimal(12, 2)
#  position             :integer
#  supplier_id          :integer
#  itinerary_id         :integer
#  product_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  length               :integer
#  comment_for_supplier :text
#  comment_for_customer :text
#  room_type            :integer
#

class ItineraryInfo < ActiveRecord::Base

 
  belongs_to  :itinerary
  belongs_to  :product
  belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id
  
  def get_product_name
    return self.product.name if self.product
  end
  
  def supplier_name
    return self.supplier.supplier_name if self.supplier
  end
  
  def room_type_name
    return self.product.rooms.find(self.room_type).name if self.room_type
  end
  
  def get_product_details
    return self.product.product_details if self.product
  end
  
  def get_product_name
    return self.product.name if self.product
  end
  
  def get_product_type
    return self.product.type.underscore.humanize if self.product
  end  
  
  def get_product_destination_id
    return self.product.destination_id if self.product
  end 
  
  def get_product_destination
    return self.product.destination.name if self.product && self.product.destination 
  end   
  
  def get_product_country_id
    return self.product.country_id if self.product 
  end
  
  def get_product_country
    return self.product.country.name if self.product && self.product.country 
  end   
  
  def select_suppliers
    # return list of potential suppliers for dropdowns
    if self.product 
      return self.product.suppliers
    else
      return []
    end
  end  
  
  def select_room_types
    # return list of potential room types for dropdowns
    if self.product 
      return self.product.rooms
    else
      return []
    end
  end 
  
  
end
