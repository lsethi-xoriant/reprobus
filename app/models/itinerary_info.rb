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
#

class ItineraryInfo < ActiveRecord::Base
  belongs_to  :itinerary
  belongs_to  :product
  
end
