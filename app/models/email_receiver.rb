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
class EmailReceiver < ActiveRecord::Base
  belongs_to :customer
end
