# == Schema Information
#
# Table name: itinerary_prices
#
#  id           :integer          not null, primary key
#  itinerary_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class ItineraryPrice < ActiveRecord::Base
  has_many      :itinerary_price_items
  
end
