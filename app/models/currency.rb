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
    return self.code + " - " + self.currency
  end
end
