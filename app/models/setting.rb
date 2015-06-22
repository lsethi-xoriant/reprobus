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
#  cc_mastercard        :decimal(5, 4)
#  cc_visa              :decimal(5, 4)
#  cc_amex              :decimal(5, 4)
#  dropbox_user         :string
#  dropbox_session      :text
#  use_dropbox          :boolean
#  dropbox_default_path :string
#

class Setting < ActiveRecord::Base
  validates_presence_of :xero_consumer_key,:xero_consumer_secret, :if => lambda { self.use_xero }
  validates_presence_of :pxpay_user_id, :pxpay_key, :if => lambda { self.payment_gateway == "Payment Express" }

  validates :cc_mastercard,:cc_visa,:cc_amex,  :numericality => {:greater_than => 0, :less_than => 1}, :allow_blank => true
  
  belongs_to :currency
  has_many :exchange_rates
  has_many :triggers, -> { order ('id ASC') }
  accepts_nested_attributes_for :triggers
 
 
  def dropbox_default_path=(value)
    if !value.blank?
      value = value + "/" if value[-1] != "/"
      value = "/" + value if value[0] != "/"
    end
    
    self[:dropbox_default_path] = value
  end
 
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
  
  def usesPaymentGateway
    return !self.payment_gateway.blank? && self.payment_gateway != "None"
  end
  
  def get_cc_mastercard_display
    return self.cc_mastercard * 100 if self.cc_mastercard
  end
  def get_cc_visa_display
    return self.cc_visa * 100 if self.cc_visa
  end
  def get_cc_other_display
    return self.cc_amex * 100 if self.cc_amex
  end
  
  def cc_mastercard=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_mastercard, value)
  end
  def cc_visa=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_visa, value)
  end
  def cc_amex=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_amex, value)
  end
  
  def is_number?(mystring)
    true if Float(mystring) rescue false
  end
  
end
