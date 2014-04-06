# == Schema Information
#
# Table name: customer_enquiries
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  enquiry_id  :integer
#  role        :string(32)
#  created_at  :datetime
#  updated_at  :datetime
#

class CustomerEnquiries < ActiveRecord::Base
end
