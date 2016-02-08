# == Schema Information
#
# Table name: itinerary_prices
#
#  id                         :integer          not null, primary key
#  itinerary_id               :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  deposit_due                :date
#  invoice_date               :date
#  balance_due                :date
#  final_balance_due          :date
#  locked                     :boolean          default("false")
#  currency_id                :integer
#  deposit                    :decimal(12, 2)   default("0.0")
#  sale_total                 :decimal(12, 2)   default("0.0")
#  deposit_system_default     :boolean          default("false")
#  booking_confirmed_date     :date
#  booking_confirmed          :boolean
#  customer_invoice_sent_date :date
#  customer_invoice_sent      :boolean
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
  
  has_many :invoices, -> { distinct }, through: :itinerary_price_items
  has_many :supplier_invoices, through: :supplier_itinerary_price_items, class_name: "Invoice", source: 'invoice' 
 
  has_many :payments
 
  def set_booking_confirmed_date 
    self.booking_confirmed_date = Date.today if !self.booking_confirmed_date && self.booking_confirmed
  end 

  def set_customer_invoice_sent_date 
    self.customer_invoice_sent_date = Date.today if !self.customer_invoice_sent_date && self.customer_invoice_sent
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
      if !price_item.invoice && price_item.supplier.email
        return true
      end
    end
    return false
  end
  
  def create_customer_invoices(user)
    return ["No uninvoiced items"] if !self.has_uninvoiced_customer_items
    
    # create one invoice - all univoiced price items go onto the one invoice
    inv = Invoice.new({invoice_date: Date.today(), final_payment_due: self.final_balance_due,  deposit_due: self.deposit_due, deposit: self.deposit })
    
    self.itinerary_price_items.each do |price_item|
      if !price_item.invoice 
        inv.line_items.build({item_price: price_item.item_price, quantity: price_item.quantity, description: price_item.description, total: price_item.price_total })
        inv.itinerary_price_items << price_item
      end
    end
    
    #self.errors.add(:invoice, inv.errors.full_messages) this doesnt work... need some better errors
    return inv.errors.full_messages if !inv.save
    
    if Setting.global_settings.use_xero
      if inv.create_invoice_xero(user)
        inv.save
      else 
        return ["Problem with xero create"]
      end
    end;
    
    return []
  end
  
  def create_supplier_invoices(user)
    return ["No uninvoiced supplier items"] if !self.has_uninvoiced_supplier_items
    
    invoices_for_xero = []
    returnMsgs = []
    
    # create one invoice for each supplier price item that is not invoiced
    self.supplier_itinerary_price_items.each do |price_item|
      if !price_item.invoice  && !price_item.supplier.email.nil?
        #find appropriate currency
        sup = price_item.supplier
        sup.currency ? currID = sup.currency_id : Setting.global_settings.currencyID
        
        inv = Invoice.new({invoice_date: Date.today(), supplier_id: sup.id, currency_id: currID, status: "New", final_payment_due: price_item.get_supplier_payment_due })  
        inv.line_items.build({item_price: price_item.item_price, quantity: price_item.quantity, description: price_item.get_supplier_invoice_description, total: price_item.price_total })
        inv.set_exchange_currency_amount
        inv.itinerary_price_items << price_item
        
        if inv.save
          invoices_for_xero << inv
        else
          returnMsgs = returnMsgs + inv.errors.full_messages
        end
      end
    end
    
    if Setting.global_settings.use_xero
      invoices_for_xero.each do |invoice|
        
        begin
          invoiceCreated = invoice.create_invoice_xero(user)
        rescue Xeroizer::ApiException => e
          invoiceCreated = false;
          returnMsgs << nice_xeroizer_ex_messages(e)
        end
        
        if invoiceCreated then 
          invoice.save
        else
          #flag as an issue, and destroy the invoice as well. so this will allow them to recreate and resend. 
          invoice.destroy
          returnMsgs << "Issue sending invoice to xero"
        end
      end
    end
    
    return returnMsgs
  end  
  
  def createSupplier
    if @invoice.save #&& err.blank?
      if Setting.find(1).use_xero
        begin
          err = @invoice.create_invoice_xero(current_user)
        rescue Xeroizer::ApiException => e
          message = nice_xeroizer_ex_messages(e)
          err = false;
        end
        
        if !err
          flash[:error] = "Warning, Xero Invoice could not be created:<br>" + message
        end
      end
      @booking.update_attribute(:status, "Invoice created")
      flash[:success] = "Invoice created!"
      redirect_to showSupplier_booking_invoices_path( @booking, @invoice)
    else
      render 'supplierInvoice'
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
  
  def get_supplier_total_exchange_rate_total
    self.supplier_itinerary_price_items.sum(:exchange_rate_total)
  end
  
  def get_total_sell_price
    self.supplier_itinerary_price_items.sum(:total_incl_markup)
  end
  
  def get_total_profit
    return self.get_total_customer_price - self.get_supplier_total_exchange_rate_total
  end

  def get_total_payments_amount
    self.payments.sum(:amount)
  end
  
  def get_total_remaining
     (get_total_customer_price - get_total_payments_amount())
  end

  def nice_xeroizer_ex_messages(exception)
    puts exception.message   # output to console to see what is going on
    errors = []
    xml = exception.parsed_xml
    xml.xpath("//ValidationError").each do |err|
      errors << err.text.gsub(/^\s+/, '').gsub(/\s+$/, '')
    end
    
    message = ""
    errors.each do |str|
      message = message + str + '<br>'
    end
    message.chomp('<br>')
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
  
  def build_pin_payments_url( amount, paymentType )
    require 'uri'
    
    callbackUri = URI.parse( "#{Setting.global_settings.base_url}/successful-pin-payment/#{self.id.to_s}/")
    
    uri = URI.parse(Setting.global_settings.pin_payment_url)
    uri.query = URI.encode_www_form(  amount: sprintf( "%.2f", amount ), 
                currency: self.currency.code, 
                description: "#{paymentType} for Booking # #{self.itinerary.id} - #{self.itinerary.name}",
                amount_editable: "false",
                success_url: callbackUri.to_s )
                                
    
    
    return uri.to_s
  end
end
