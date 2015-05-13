# == Schema Information
#
# Table name: itinerary_templates
#
#  id         :integer          not null, primary key
#  name       :string
#  includes   :text
#  excludes   :text
#  notes      :text
#  created_at :datetime
#  updated_at :datetime
#

class ItineraryTemplate < ActiveRecord::Base
  has_many  :itinerary_template_infos
  
end
