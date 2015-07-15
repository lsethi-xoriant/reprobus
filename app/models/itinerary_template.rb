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
#  type       :string
#  start_date :date
#  end_date   :date
#

class ItineraryTemplate < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :itineraries
  has_many :itinerary_template_infos, -> { order("position ASC")}
  accepts_nested_attributes_for :itinerary_template_infos, allow_destroy: true
  
end
