# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  currency   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Currency < ActiveRecord::Base
  
  def displayName
    return "#{self.code} - #{self.currency}"
  end
  
  def getCurrencyRate
  
    overRideExRate = Setting.global_settings.exchange_rates.find_by_currency_code(self.code)
    if overRideExRate
      return overRideExRate.exchange_rate
    end
    
    if self.id == Setting.global_settings.currency_id
      return 1.00
    end
    
    return 0.00
  end
  
end
