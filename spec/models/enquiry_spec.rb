# == Schema Information
#
# Table name: enquiries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  assigned_to      :integer
#  name             :string(64)       default(""), not null
#  access           :string(8)        default("Public")
#  source           :string(32)
#  stage            :string(32)
#  probability      :integer
#  amount           :decimal(12, 2)
#  discount         :decimal(12, 2)
#  closes_on        :date
#  deleted_at       :datetime
#  background_info  :string(255)
#  subscribed_users :text
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Enquiry do
  pending "add some examples to (or delete) #{__FILE__}"
end
