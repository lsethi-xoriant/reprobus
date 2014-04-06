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

require 'spec_helper'

describe CustomerEnquiry do
  pending "add some examples to (or delete) #{__FILE__}"
end
