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
#  offset               :integer          default("0")
#  days_from_start      :integer
#  includes_breakfast   :boolean
#  includes_lunch       :boolean
#  includes_dinner      :boolean
#  group_classification :string
#

class ItineraryInfo < ActiveRecord::Base
  validates :offset, :numericality => {:allow_blank => true}
  validates :length, :numericality => {:allow_blank => true}
 
  belongs_to  :itinerary
  belongs_to  :product
  belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id

  def offset=(value)
    write_attribute(:offset, value.to_i.abs)
  end
  
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

  def get_product_description
    return self.product.description if self.product
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
  
  def get_product_address
    return self.product.address if self.product
  end   
  
  def get_product_phone
    return self.product.phone if self.product
  end   
  
  
  def get_group_classification
    if (self.get_product_type == "Transfer" || self.get_product_type == "Tour") && self.group_classification != "None" 
      return self.group_classification
    else
      return ""
    end
  end
  
  def get_itinerary_header_details(prefix)
    #group = self.get_group_classification
    #group += " " if !group.blank?
    prefix += " - " if !prefix.blank? 
    #str = "#{group}#{prefix}#{self.get_product_name}  #{self.get_product_destination}, #{self.get_product_country}"
    str = "#{prefix}#{self.get_product_name}  #{self.get_product_destination}, #{self.get_product_country}"
    return str
  end

  def get_itinerary_header_details_cruiseday(prefix)
    prefix += " - " if !prefix.blank? 
    #str = "#{group}#{prefix}#{self.get_product_name}  #{self.get_product_destination}, #{self.get_product_country}"
    roomtype = " - #{self.room_type_name}" if !self.room_type_name.blank?
    str = "#{prefix}#{self.get_product_name}#{roomtype}"
    return str
  end

  def has_meal_inclusions
      return (self.includes_breakfast or self.includes_lunch or self.includes_dinner)
  end

  def get_meal_inclusions
    breakfast = "Breakfast   " if self.includes_breakfast
    lunch = "Lunch   " if self.includes_lunch
    dinner = "Dinner   " if self.includes_dinner
    
    meals = "#{breakfast}#{lunch}#{dinner}"
    return meals
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
