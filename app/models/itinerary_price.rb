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
#  booking_confirmed_date :date
#  booking_confirmed      :boolean
#

class ItineraryPrice < ActiveRecord::Base
  before_save :set_booking_confirmed_date, if: :booking_confirmed_changed?
  before_save :set_customer_invoice_sent_date, if: :customer_invoice_sent_changed?
  
  has_many      :itinerary_price_items, -> { order "created_at ASC" }
  accepts_nested_attributes_for :itinerary_price_items, allow_destroy: true
  
  has_many      :supplier_itinerary_price_items, -> { order "created_at ASC" }, :class_name => "ItineraryPriceItem", :foreign_key => :supplier_itinerary_price_id
  accepts_nested_attributes_for :supplier_itinerary_price_items, allow_destroy: true

  
  belongs_to :itinerary
  belongs_to :currency
  
  has_many :invoices, through: :itinerary_price_items 
  has_many :supplier_invoices, through: :supplier_itinerary_price_items, class_name: "Invoice" 
 
 
  def set_booking_confirmed_date 
    self.booking_confirmed_date = Date.today if !self.booking_confirmed_date
  end 

  def set_customer_invoice_sent_date 
    self.customer_invoice_sent_date = Date.today if !self.customer_invoice_sent_date
  end 
  
  def has_uninvoiced_customer_items
    self.itinerary_price_items.each do |price_item|
      if !price_item.invoice
        return true
      end
    end
    return false
  end
 
  def has_uninvoiced_supplier_items
    self.supplier_itinerary_price_items.each do |price_item|
      if !price_item.invoice
        return true
      end
    end
    return false
  end
  
  def create_customer_invoices(user)
    return if !self.has_uninvoiced_customer_items
    
    inv = Invoice.new({invoice_date: Date.today(), final_payment_due: self.final_balance_due,  deposit_due: self.deposit_due, deposit: self.deposit })
    
    self.itinerary_price_items.each do |price_item|
      if !price_item.invoice 
        inv.line_items.build({item_price: price_item.item_price, quantity: price_item.quantity, description: price_item.description, total: price_item.price_total })
        inv.itinerary_price_items << price_item
      end
    end
    
    if inv.create_invoice_xero(user)
      inv.save
    end
    
  end
  
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
  
  def get_consultant_display
    return  self.itinerary.enquiry.assigned_to_name
  end
  
  def get_total_customer_price
    self.itinerary_price_items.sum(:price_total)
  end
  
  def get_total_supplier_price
    self.supplier_itinerary_price_items.sum(:price_total)
  end
  
  def get_total_supplier_sell_total
    self.supplier_itinerary_price_items.sum(:exchange_rate_total)
  end
  
  def get_total_incl_supplier_markup
    self.supplier_itinerary_price_items.sum(:total_incl_markup)
  end
  
  def get_total_supplier_profit
    return get_total_incl_supplier_markup - get_total_supplier_sell_total
  end
  
  
  def new_setup
    setting = Setting.global_settings
    self.currency_id = setting.getDefaultCurrency.id
    
    supArray = []
    
    setting.suppliers.each do |sup|
      supArray << sup if !supArray.include?(sup)
    end
    
    self.itinerary.itinerary_infos.each do |info|
      supArray << info.supplier if info.supplier && !supArray.include?(info.supplier)
    end
    
    supArray.each do |sup|
      self.supplier_itinerary_price_items.build({supplier_id: sup.id, currency_id: sup.currency_id, sell_currency_rate: sup.getSupplierCurrencyRateDefault})
    end
    
    self.itinerary_price_items.build({description: self.itinerary.name, start_date: self.itinerary.start_date, end_date: self.itinerary.get_end_date, quantity: self.itinerary.num_passengers })
    
    self.invoice_date = Date.today
    self.deposit_due  = Date.today + 2
    self.final_balance_due = Date.today + 95
  end
  
end
