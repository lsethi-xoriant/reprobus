# == Schema Information
#
# Table name: email_receivers
#
#  id          :integer          not null, primary key
#  uniqueID    :string(255)
#  customer_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe EmailReceiver do
  pending "add some examples to (or delete) #{__FILE__}"
end
