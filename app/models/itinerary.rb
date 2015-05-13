# == Schema Information
#
# Table name: itineraries
#
#  id               :integer          not null, primary key
#  name             :string
#  start_date       :date
#  num_passengers   :integer
#  complete         :boolean
#  sent             :boolean
#  quality_check    :boolean
#  price_per_person :decimal(12, 2)
#  price_total      :decimal(12, 2)
#  bed              :string
#  includes         :text
#  excludes         :text
#  notes            :text
#  flight_reference :string
#  user_id          :integer
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Itinerary < ActiveRecord::Base
  belongs_to    :user
  has_many      :itinerary_infos
  has_one       :itinerary_price
  
end
