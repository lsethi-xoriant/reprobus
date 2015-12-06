# == Schema Information
#
# Table name: itinerary_price_items
#
#  id                          :integer          not null, primary key
#  booking_ref                 :string
#  description                 :string
#  price_total                 :decimal(12, 2)   default("0.0")
#  supplier_id                 :integer
#  itinerary_price_id          :integer
#  created_at                  :datetime
#  updated_at                  :datetime
#  supplier_itinerary_price_id :integer
#  invoice_id                  :integer
#  quantity                    :integer          default("0")
#  item_price                  :decimal(12, 2)   default("0.0")
#  deposit                     :integer          default("0")
#  start_date                  :date
#  currency_id                 :integer
#  markup_percentage           :integer
#  end_date                    :date
#  sell_currency_rate          :decimal(12, 2)   default("0.0")
#

class ItineraryPriceItem < ActiveRecord::Base
  validates :item_price, presence: true
  validates :quantity, presence: true
  validates :description, presence: true, if: Proc.new { |i| i.supplier_id.blank? }
  
  belongs_to      :itinerary_price
  belongs_to      :supplier, :class_name => "Customer", :foreign_key => "supplier_id"
  belongs_to      :currency

  def currencyID
    self.currency_id ? self.currency_id : Setting.global_settings.getDefaultCurrency.id
  end
  
  def currencyCode
    self.currency_id ? self.currency.code : Setting.global_settings.getDefaultCurrency.code
  end
  
  def currencyDisplay
    self.currency_id ? self.currency.displayName : Setting.global_settings.getDefaultCurrency.displayName
  end   
end
