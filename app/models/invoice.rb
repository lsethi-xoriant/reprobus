# == Schema Information
#
# Table name: invoices
#
#  id                  :integer          not null, primary key
#  booking_id          :integer
#  status              :string(255)
#  invoice_date        :datetime
#  deposit_due         :datetime
#  final_payment_due   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  deposit             :decimal(12, 2)
#  depositPayUrl       :string(255)
#  ccPaymentsAmount    :text
#  ccPaymentsDate      :text
#  supplier_invoice_id :integer
#  customer_invoice_id :integer
#  currency            :string(255)
#  xero_id             :string(255)
#  xdeposits           :text
#  xpayments           :text
#  supplier_id         :integer
#  currency_id         :integer
#  exchange_amount     :decimal(12, 2)
#  exchange_rate       :decimal(12, 2)
#

class Invoice < ActiveRecord::Base
  belongs_to :supplier, :class_name => "Customer", :foreign_key => :supplier_id
  belongs_to :booking
  has_many   :line_items, dependent: :destroy
  validates  :invoice_date, presence: true
  validates  :final_payment_due, presence: true
  validates_presence_of :line_items
  serialize  :ccPaymentsAmount
  serialize  :ccPaymentsDate
  serialize  :xpayments
  serialize  :xdeposits
  validate   :validate_customer_invoice # validate deposit is set, and deposit due date.
  validate   :validate_supplier_invoice # validate it has a supplier set.
  belongs_to :currency
  has_many   :payments, dependent: :destroy
  has_one    :x_invoice
  
  validate do |invoice|
    int = 0;
    invoice.line_items.each do |li|
      int += 1
      next if li.valid?
      li.errors.full_messages.each do |msg|
        invoice.errors[:base] << "Line item #{int.to_s} error: #{msg}"
      end
    end
  end
  
  def validate_customer_invoice
    if self.customer_invoice_id
      if self.deposit.blank?
         errors.add(:deposit, "can't be blank")
      end
      if self.deposit_due.blank?
        errors.add(:deposit_due, "can't be blank")
      end
    end
  end
  
  def validate_supplier_invoice
    if self.isSupplierInvoice?
      if self.supplier.nil?
        errors.add(:Supplier, "must be selected")
      end
    end
  end
  
  def isSupplierInvoice?
    return !self.supplier_invoice_id.blank?
  end
  
  def addCCPayment!(amount)
    ccArr =  self.ccPaymentsAmount || []
    dateArr =  self.ccPaymentsDate || []
    ccArr << amount
    dateArr << Date.today
    self.update_attribute(:ccPaymentsAmount, ccArr)
    self.update_attribute(:ccPaymentsDate, dateArr)
  end
  
  def getCCPaidTotal
    tot = 0
    pays = self.payments.ccPayments
    pays.each do |pay|
        tot = tot + pay.amount
    end
    return tot
  end

  def getDDPaidTotal
    tot = 0
    pays = self.payments.ddPayments
    pays.each do |pay|
        tot = tot + pay.amount
    end
    return tot
  end
  
  def getPaidTotal
    tot = 0
    if self.x_invoice
      tot = self.x_invoice.amount_paid
    else
      tot = self.getCCPaidTotal + self.getDDPaidTotal
    end
    return tot
  end
  
  def getTotalAmount
    total = 0
    self.line_items.each do |item|
      total = total + item.total
    end
    return total
  end
  
  def getBalance
    return getTotalAmount - getPaidTotal
  end
  
  def create_invoice_xero(user)
    xero = Xero.new()
    # TODO need some error handling in here.
    success = xero.create_invoice(self)

    return success
  end
  
  def get_invoice_xero
    xero = Xero.new()
    inv = xero.get_invoice(self.xero_id)
    return inv
  end
  
  def sync_invoice
    xero = Xero.new()
    inv = xero.sync_invoice(self)
    return inv
  end
  
  def add_xero_payment(amount)
    xero = Xero.new()
    # TODO need some error handling in here.
    xero.create_payment(self, amount)
        
    #act = self.activities.create(type: "Note", description: "Payment submitted to xero:  $#{amount}")
    #if act
    #  user.activities<<(act)
    #end
  end
  
  def change_xero_invoice(amount)
    xero = Xero.new()
    # TODO need some error handling in here.
    xero.change_invoice(self, amount)
        
    #act = self.activities.create(type: "Note", description: "Payment submitted to xero:  $#{amount}")
    #if act
    #  user.activities<<(act)
    #end
  end
  
  def getPayExpressUrl(deposit)
    
    if deposit && !self.pxpay_deposit_url.nil?
      return self.pxpay_deposit_url  #using this because pxpay 2.0 only allows URL generation for a trx ever 48hrs.
      # may not be an issue when we use pxpay in live...(dev envio conected to pxpay2.0)
    end
    
    if !deposit && !self.pxpay_balance_url.nil?
      return self.pxpay_balance_url  #using this because pxpay 2.0 only allows URL generation for a trx ever 48hrs.
    end
     
    @setting = Setting.find(1);
    
    if @setting.payment_gateway != "Payment Express"
      return ""
    end
    
    require 'nokogiri'
    require 'pxpay'
    
    Pxpay::Base.pxpay_user_id = @setting.pxpay_user_id
    Pxpay::Base.pxpay_key = @setting.pxpay_key
    Pxpay::Base.pxpay_request_url = 'https://sec.paymentexpress.com/pxaccess/pxpay.aspx'
    
    #transId = self.id
    strRef = "Booking payment for " + self.booking.name
    succpath = Rails.application.routes.url_helpers.pxpaymentsuccess_url()
    failpath = Rails.application.routes.url_helpers.pxpaymentfailure_url()
    curCode = self.getCurrencyCode
    
    if deposit
      amount = self.deposit.to_s
      trxID = self.id.to_s + "_deposit"
    else
      amount = self.getBalance.to_s
      trxID = self.id.to_s + "_balance"
    end
    
    request = Pxpay::Request.new(trxID, amount, {:url_success => succpath, :url_failure => failpath, :merchant_reference => strRef, :currency_input => curCode})
    url = request.url
    
    #saving URL because pxpay 2.0 only allows URL generation for a trx ever 48hrs.  - may not be an issue when we use pxpay in live...
    if deposit
      self.update_attribute(:pxpay_deposit_url, url)
      self.update_attribute(:pxpay_deposit_trxId, trxID)
    else
      self.update_attribute(:pxpay_balance_url, url)
      self.update_attribute(:pxpay_balance_trxId, trxID)
    end
  
    return url
  end
  
  def nice_id
    self.id.to_s.rjust(6, '0')
  end
  
  def getSupplierName
    self.supplier ? self.supplier.supplier_name : ""
  end
  
  def getCurrencyCode
    self.currency ? self.currency.code : Setting.find(1).currencyCode
  end
 
  def getCurrencyDisplay
    self.currency ? self.currency.displayName : Setting.find(1).currencyDisplay
  end
  
  def getCurrencySelect2
    if self.currency
      return self.currency.id.to_s + ":" + self.currency.code + " - " + self.currency.currency
    else
      return ""
    end
  end
  
  def get_current_exchange_amount
    code = self.getCurrencyCode
    syscode = Setting.find(1).currencyCode
    
    # get the total amount and times by 100 as Money uses cents.
    mon = Money.new((self.getTotalAmount * 100).to_i, code)
    exch = mon.exchange_to(syscode)
    return exch.dollars
  end
  
  def set_exchange_currency_amount
    code = self.getCurrencyCode
    syscode = Setting.find(1).currencyCode
    overRideExRate = Setting.find(1).exchange_rates.find_by_currency_code(code)
    
    if overRideExRate
      googleBank = Money.default_bank # save google currency ex, so we can set it back later.
      
      # set up a new default bank so we can override the currency ex rate.
      Money.default_bank = Money::Bank::VariableExchange.instance
      Money.add_rate(code, syscode, overRideExRate.exchange_rate)
      
      mon = Money.new((self.getTotalAmount * 100).to_i, code)
      exch = mon.exchange_to(syscode)
      self.exchange_amount = exch.dollars
      self.exchange_rate = overRideExRate.exchange_rate
      
      # now set back to default google rates
      Money.default_bank = googleBank
    else
      # get the total amount and times by 100 as Money uses cents.
      mon = Money.new((self.getTotalAmount * 100).to_i, code)
      exch = mon.exchange_to(syscode)
      self.exchange_amount = exch.dollars
      self.exchange_amount = exch.dollars
      if code == syscode
        self.exchange_rate = 1.00
      else
        self.exchange_rate = Money.default_bank.get_rate(code, syscode)
      end
    end
  end
end

