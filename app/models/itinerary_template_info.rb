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
#

class ItineraryTemplateInfo < ActiveRecord::Base
  validates :product_id, presence: true
  validates :length, presence: true
  validates :days_from_start, presence: true
    
  belongs_to  :itinerary_template
  belongs_to  :product

  def get_product_details
    return self.product.product_details if self.product
  end
  
  def get_product_name
    return self.product.name if self.product
  end
  
  def get_product_destination_id
    return self.product.destination_id if self.product 
  end   
  
  def get_product_destination
    return self.product.destination.name if self.product && self.product.destination 
  end     
end

