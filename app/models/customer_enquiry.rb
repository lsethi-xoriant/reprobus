# == Schema Information
#
# Table name: customer_enquiries
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  enquiry_id  :integer
#  role        :string(32)
#  deleted_at  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class CustomerEnquiry < ActiveRecord::Base
  belongs_to :customer
  belongs_to :enquiry
  validates_presence_of :customer_id, :enquiry_id 
end
