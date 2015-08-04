# == Schema Information
#
# Table name: itinerary_template_infos
#
#  id                    :integer          not null, primary key
#  position              :integer
#  length                :integer
#  days_from_start       :integer
#  product_id            :integer
#  itinerary_template_id :integer
#  created_at            :datetime
#  updated_at            :datetime
#  supplier_id           :integer
#  offset                :integer          default("0")
#

class ItineraryTemplateInfo < ActiveRecord::Base
  validates :product_id, presence: true
  validates :length, presence: true
  validates :offset, :numericality => {:allow_blank => true}
  validates :length, :numericality => {:allow_blank => true}
    
  belongs_to  :itinerary_template
  belongs_to  :product
  belongs_to  :supplier, :class_name => "Customer", :foreign_key => :supplier_id

  def offset=(value)
    write_attribute(:offset, value.to_i.abs)
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
  
  def get_supplier_name
    return self.supplier.name if self.supplier 
  end  
  
  def select_suppliers
    # return list of potential suppliers for dropdowns
    if self.product 
      return self.product.suppliers
    else
      return []
    end
  end
end

