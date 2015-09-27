# == Schema Information
#
# Table name: itinerary_templates
#
#  id                         :integer          not null, primary key
#  name                       :string
#  includes                   :text
#  excludes                   :text
#  notes                      :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type                       :string
#  start_date                 :date
#  end_date                   :date
#  itinerary_default_image_id :integer
#

class ItineraryTemplate < ActiveRecord::Base
  validates :name, presence: true
  
  has_many :itineraries
  has_many :itinerary_template_infos, -> { order("position ASC")}
  accepts_nested_attributes_for :itinerary_template_infos, allow_destroy: true
  belongs_to  :itinerary_default_image, :class_name => "ImageHolder", :foreign_key => :itinerary_default_image_id
  accepts_nested_attributes_for :itinerary_default_image, allow_destroy: true
  
end
