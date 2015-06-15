# == Schema Information
#
# Table name: itinerary_infos
#
#  id                  :integer          not null, primary key
#  name                :string
#  start_date          :date
#  end_date            :date
#  country             :string
#  city                :string
#  product_type        :string
#  product_name        :string
#  product_description :string
#  product_price       :string
#  rating              :string
#  room_type           :string
#  price_per_person    :decimal(12, 2)
#  price_total         :decimal(12, 2)
#  position            :integer
#  supplier_id         :integer
#  itinerary_id        :integer
#  product_id          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  length              :integer
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
  
  def get_product_details
    return self.product.product_details if self.product
  end
  
  def get_product_destination_id
    return self.product.destination_id if self.product.destination
  end  
end
