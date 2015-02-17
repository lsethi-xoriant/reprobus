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
  
  def currencyID
    if self.currency
      return self.currency.id
    else
      return "8"  # this is default aus dollars
    end
  end
  
  def currencyDisplay
    if self.currency
      return self.currency.displayName
    else
      return "No System Default Set"
    end
  end    
  
  def getCurrencySelect2
    if self.currency.blank?
      return "";
    else
      return self.currency.id.to_s + ":" + self.currency.code + " - " + self.currency.currency
    end
  end
end
