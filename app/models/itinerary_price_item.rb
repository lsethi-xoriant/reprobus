# == Schema Information
#
# Table name: itinerary_price_items
#
#  id                 :integer          not null, primary key
#  booking_ref        :string
#  description        :string
#  price_total        :decimal(12, 2)
#  supplier_id        :integer
#  itinerary_price_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class ItineraryPriceItem < ActiveRecord::Base
  belongs_to      :itinerary_price
  has_one         :supplier,  :foreign_key => "supplier_id", :class => "Customer"
  
end
