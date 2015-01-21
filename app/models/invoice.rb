# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  booking_id        :integer
#  status            :string(255)
#  invoice_date      :datetime
#  deposit_due       :datetime
#  final_payment_due :datetime
#  created_at        :datetime
#  updated_at        :datetime
#  deposit           :decimal(12, 2)
#

class Invoice < ActiveRecord::Base
  belongs_to  :booking
  has_many    :line_items, dependent: :destroy
  validates :invoice_date, presence: true
  validates :deposit_due, presence: true
  validates :final_payment_due, presence: true
  validates :deposit, presence: true
  validates_presence_of :line_items
  serialize :ccPaymentsAmount
  serialize :ccPaymentsDate


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
  
  def addCCPayment!(amount)
    ccArr =  self.ccPaymentsAmount || [] 
    dateArr =  self.ccPaymentsDate || [] 
    ccArr << amount
    dateArr << Date.today
    self.update_attribute(:ccPaymentsAmount, ccArr)
    self.update_attribute(:ccPaymentsDate, dateArr)
  end
  
  def getCCPaidTotal
    ccArr = self.ccPaymentsAmount
    tot = 0
    if !ccArr.nil?
      ccArr.each do |amount|
        tot = tot + amount.to_f
      end
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
  
  def getPayExpressUrl
    if !self.depositPayUrl.nil?
      return self.depositPayUrl  #using this because pxpay 2.0 only allows URL generation for a trx ever 48hrs.  - may not be an issue when we use pxpay in live...
    end
    
    require 'nokogiri' 
    require 'pxpay'
    
    @setting = Setting.find(1);
    
    #if Rails.env.development? || Rails.env.test?  || Rails.env.production?  #take of production later when ready to go live
    #  Pxpay::Base.pxpay_user_id = "Samplepxpayuser"
    #  Pxpay::Base.pxpay_key = "cff9bd6b6c7614bec6872182e5f1f5bcc531f1afb744f0bcaa00e82ad3b37f6d" 
    #else
      Pxpay::Base.pxpay_user_id = @setting.pxpay_user_id
      Pxpay::Base.pxpay_key = @setting.pxpay_key     
    #end
    Pxpay::Base.pxpay_request_url = 'https://sec.paymentexpress.com/pxaccess/pxpay.aspx'
    
    #transId = self.id
    strRef = "Booking payment for " + self.booking.name
    succpath = Rails.application.routes.url_helpers.pxpaymentsuccess_url()
    failpath = Rails.application.routes.url_helpers.pxpaymentfailure_url()
    
    request = Pxpay::Request.new(self.id, self.deposit.to_s, {:url_success => succpath, :url_failure => failpath, :merchant_reference => strRef, :currency_input => "AUD"})    
    url = request.url
    self.update_attribute(:depositPayUrl, url) #saving this because pxpay 2.0 only allows URL generation for a trx ever 48hrs.  - may not be an issue when we use pxpay in live...
    return url
  end
end

