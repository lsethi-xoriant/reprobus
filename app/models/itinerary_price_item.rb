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
#  deposit_percentage          :integer          default("0")
#  start_date                  :date
#  currency_id                 :integer
#  markup_percentage           :integer
#  end_date                    :date
#  sell_currency_rate          :decimal(12, 2)   default("0.0")
#  deposit                     :decimal(12, 2)   default("0.0")
#  markup                      :decimal(12, 2)   default("0.0")
#  exchange_rate_total         :decimal(12, 2)   default("0.0")
#  total_incl_markup           :decimal(12, 2)   default("0.0")
#

class ItineraryPriceItem < ActiveRecord::Base
  validates :item_price, presence: true
  validates :quantity, presence: true
  validates :description, presence: true, if: Proc.new { |i| i.supplier_id.blank? }
  
  belongs_to      :itinerary_price
  belongs_to      :supplier_itinerary_price, 
                  class_name: 'ItineraryPrice',
                  foreign_key: 'supplier_itinerary_price_id'

  belongs_to      :supplier, :class_name => "Customer", :foreign_key => "supplier_id"
  belongs_to      :currency
  belongs_to      :invoice

  def currencyID
    self.currency_id ? self.currency_id : Setting.global_settings.getDefaultCurrency.id
  end
  
  def currencyCode
    self.currency_id ? self.currency.code : Setting.global_settings.getDefaultCurrency.code
  end
  
  def currencyDisplay
    self.currency_id ? self.currency.displayName : Setting.global_settings.getDefaultCurrency.displayName
  end
  
  def get_item_sell_total
    return self.quantity * self.item_price
  end
  
  def get_exchange_total
    return self.sell_currency_rate * self.price_total
  end
  
  def get_sell_currency_rate
    if self.sell_currency_rate == 0.0
      return "1.0"
    end
    return self.sell_currency_rate
  end
  
  def get_supplier_payment_due
    # 30 days prior to start date, or today if that is in past. # or check supplier for configured date. 
    date = self.supplier_itinerary_price.itinerary.start_date - 30
    date = Date.today if date.past
    if self.supplier && self.supplier.num_days_payment_due
      date = self.supplier_itinerary_price.itinerary.start_date - self.supplier.num_days_payment_due
    end 
  end
end
