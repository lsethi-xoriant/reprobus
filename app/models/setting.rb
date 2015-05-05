# == Schema Information
#
# Table name: settings
#
#  id                   :integer          not null, primary key
#  company_name         :string(255)
#  pxpay_user_id        :string(255)
#  pxpay_key            :string(255)
#  use_xero             :boolean
#  xero_consumer_key    :string(255)
#  xero_consumer_secret :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  currency_id          :integer
#  payment_gateway      :string(255)
#

class Setting < ActiveRecord::Base
  validates_presence_of :xero_consumer_key, :if => lambda { self.use_xero }
  validates_presence_of :xero_consumer_secret, :if => lambda { self.use_xero }
  validates_presence_of :pxpay_user_id, :if => lambda { self.payment_gateway == "Payment Express" }
  validates_presence_of :pxpay_key, :if => lambda { self.payment_gateway == "Payment Express" }
  
  belongs_to :currency
  has_many :exchange_rates
  has_many :triggers, -> { order ('id ASC') }
  accepts_nested_attributes_for :triggers
  
  def getDefaultCurrency
    self.currency ? self.currency : Currency.find_by_code("USD")
  end
  def currencyID
    return self.getDefaultCurrency.id
  end
  def currencyCode
    return self.getDefaultCurrency.code
  end
  def currencyDisplay
    return self.getDefaultCurrency.displayName
  end
  def getCurrencySelect2
    return self.getDefaultCurrency.id.to_s + ":" + self.getDefaultCurrency.code + " - " + self.getDefaultCurrency.currency
  end
  
  def usesPaymentGateway
    return !self.payment_gateway.blank? && self.payment_gateway != "None"
  end
end
