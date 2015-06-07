# == Schema Information
#
# Table name: bookings
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  enquiry_id  :integer
#  user_id     :integer
#  amount      :decimal(12, 2)   default("0.0")
#  deposit     :decimal(12, 2)   default("0.0")
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  xpayments   :text
#  xero_id     :string(255)
#  xdeposits   :text
#  agent_id    :integer
#

require 'spec_helper'

describe Booking do
  pending "add some examples to (or delete) #{__FILE__}"
end
