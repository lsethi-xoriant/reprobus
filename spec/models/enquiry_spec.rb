# == Schema Information
#
# Table name: enquiries
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  assigned_to        :integer
#  name               :string(64)       default(""), not null
#  access             :string(8)        default("Public")
#  source             :string(32)
#  stage              :string(32)
#  probability        :string(255)
#  amount             :decimal(12, 2)   default("0.0"), not null
#  discount           :decimal(12, 2)   default("0.0"), not null
#  closes_on          :date
#  deleted_at         :datetime
#  background_info    :string(255)
#  subscribed_users   :text
#  created_at         :datetime
#  updated_at         :datetime
#  duration           :string(255)
#  est_date           :date
#  num_people         :string(255)
#  percent            :integer
#  fin_date           :date
#  standard           :string(255)
#  insurance          :boolean
#  reminder           :date
#  xero_id            :string(255)
#  xpayments          :text
#  agent_id           :integer
#  lead_customer_id   :integer
#  lead_customer_name :string
#  destination_id     :integer
#  campaign           :text
#

require 'spec_helper'

describe Enquiry do
  pending "add some examples to (or delete) #{__FILE__}"
end
