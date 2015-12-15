# == Schema Information
#
# Table name: exchange_rates
#
#  id            :integer          not null, primary key
#  exchange_rate :decimal(12, 5)
#  currency_code :string(255)
#  setting_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class ExchangeRate < ActiveRecord::Base
  validates  :exchange_rate, presence: true
  validates  :currency_code, presence: true

  
  def getTodayExRate
    code = self.currency_code
    syscode = Setting.find(1).currencyCode 
    
    # get the total amount and times by 100 as Money uses cents.     
    mon = Money.new(100, syscode)
    exch = mon.exchange_to(code)
    return exch.dollars    
  end
end


