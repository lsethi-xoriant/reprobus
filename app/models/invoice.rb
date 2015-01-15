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
  
  
  def getTotalAmount
    total = 0
    self.line_items.each do |item|
      total = total + item.total
    end
    return total
  end
  
  def getPayExpressUrl
    require 'nokogiri' 
    require 'pxpay'
    
    Pxpay::Base.pxpay_user_id = 'Samplepxpayuser'
    Pxpay::Base.pxpay_key = 'cff9bd6b6c7614bec6872182e5f1f5bcc531f1afb744f0bcaa00e82ad3b37f6d'
    
    request = Pxpay::Request.new( self.id, 1000, {:url_success => 'https://www.dpsdemo.com/SandboxSuccess.aspx', :url_failure => 'https://www.dpsdemo.com/SandboxSuccess.aspx'})
    request.url
  end
end

