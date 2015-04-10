# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  amount      :decimal(12, 5)
#  payment_ref :string(255)
#  invoice_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  reference   :text
#  date        :date
#

class Payment < ActiveRecord::Base
  belongs_to  :invoice
  
end
