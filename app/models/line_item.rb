# == Schema Information
#
# Table name: line_items
#
#  id          :integer          not null, primary key
#  invoice_id  :integer
#  item_price  :decimal(12, 2)   default("0.0")
#  total       :decimal(12, 2)   default("0.0")
#  description :string(255)
#  quantity    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deposit     :integer
#

class LineItem < ActiveRecord::Base
  belongs_to  :invoice
  validates :item_price, presence: true
  validates :quantity, presence: true
  validates :description, presence: true
  
end
