# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  customer_id :integer
#  user_id     :integer
#  user_email  :string(255)
#  enquiry_id  :integer
#

class Activity < ActiveRecord::Base
  validates :type, presence: true
  validates :description, presence: true
  belongs_to  :customer
  belongs_to  :user
  belongs_to  :enquiry
  
end
