# == Schema Information
#
# Table name: itinerary_prices
#
#  id                :integer          not null, primary key
#  itinerary_id      :integer
#  created_at        :datetime
#  updated_at        :datetime
#  deposit_due       :date
#  invoice_date      :date
#  balance_due       :date
#  final_balance_due :date
#

class ItineraryPrice < ActiveRecord::Base
  has_many      :itinerary_price_items
  accepts_nested_attributes_for :itinerary_price_items, allow_destroy: true
  belongs_to :itinerary
  
  
  def get_agent_display
    if self.itinerary.enquiry.agent 
      return self.itinerary.enquiry.agent.fullname
    else
      return "N/A"
    end
  end
  
  def get_consultant_display
    return  self.itinerary.enquiry.assigned_to_name
  end  
  
  def get_total_customer_price
    total = 0.00
    self.itinerary_price_items.each do |ipi|
      total = total + ipi.price_total
    end
    return "$#{total}"
  end
  

    
end
