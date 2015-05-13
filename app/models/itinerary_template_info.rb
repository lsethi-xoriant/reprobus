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
  belongs_to  :itinerary_template
  belongs_to  :product
  
end
