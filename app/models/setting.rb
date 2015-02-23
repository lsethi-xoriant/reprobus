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
#

class Setting < ActiveRecord::Base
  validates_presence_of :xero_consumer_key, :if => lambda { self.use_xero }
  validates_presence_of :xero_consumer_secret, :if => lambda { self.use_xero }
  belongs_to :currency
  
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
end
