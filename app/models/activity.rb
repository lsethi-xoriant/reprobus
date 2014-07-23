# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Activity < ActiveRecord::Base
  validates :type, presence: true
  validates :description, presence: true
  belongs_to  :customer
  belongs_to  :user
  
end
