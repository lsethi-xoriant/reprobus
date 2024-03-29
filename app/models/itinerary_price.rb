# == Schema Information
#
# Table name: itinerary_prices
#
#  id                     :integer          not null, primary key
#  itinerary_id           :integer
#  created_at             :datetime
#  updated_at             :datetime
#  deposit_due            :date
#  invoice_date           :date
#  balance_due            :date
#  final_balance_due      :date
#  locked                 :boolean          default("false")
#  currency_id            :integer
#  deposit                :decimal(12, 2)   default("0.0")
#  sale_total             :decimal(12, 2)   default("0.0")
#  deposit_system_default :boolean          default("false")
#

class ItineraryPrice < ActiveRecord::Base
  has_many      :itinerary_price_items, -> { order "created_at ASC" }
  accepts_nested_attributes_for :itinerary_price_items, allow_destroy: true
  
  has_many      :supplier_itinerary_price_items, -> { order "created_at ASC" }, :class_name => "ItineraryPriceItem", :foreign_key => :supplier_itinerary_price_id
  accepts_nested_attributes_for :supplier_itinerary_price_items, allow_destroy: true

  has_many    :customer_invoices, :class_name => "Invoice", :foreign_key => :customer_itinerary_price_id
  has_many    :supplier_invoices, :class_name => "Invoice", :foreign_key => :supplier_itinerary_price_id
  
  belongs_to :itinerary
  belongs_to :currency
 
 
  def get_agent_display
    if self.itinerary.enquiry.agent 
      return self.itinerary.enquiry.agent.fullname
    else
      return "N/A"
    end
  end
  
  def get_currency_display
    return self.currency.displayName if self.currency
  end

  def get_sale_total_display
    return "$" + self.sale_total.to_s
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
  
  def new_setup
    setting = Setting.global_settings
    
    self.currency_id = setting.getDefaultCurrency.id
    
    supArray = []
    
    setting.suppliers.each do |sup|
      if !supArray.include?(sup)
        self.supplier_itinerary_price_items.build({supplier_id: sup.id, currency_id: sup.currency_id})
        supArray << sup
      end
    end
    
    self.itinerary.itinerary_infos.each do |info|
      if info.supplier && !supArray.include?(info.supplier)
        self.supplier_itinerary_price_items.build({supplier_id: info.supplier.id})
        supArray << info.supplier
      end
    end 
  end
  
end
