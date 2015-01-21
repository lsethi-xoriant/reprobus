class Xero
# using PrivateApplication which expires every 30 days!!!
  
   require 'rubygems'
   require 'xeroizer'
  
  attr_accessor :client
  
   #CONSUM_KEY = "VNC0RNRCXH3BPNK4GDCK0J4SLMSX68"
   #OAUTH_SECRET_KEY = "DBDRCQLMZABOSGZHCBTVWLXTCJDRUA"
   CONSUM_KEY = Setting.find(1).xero_consumer_key  
   OAUTH_SECRET_KEY = Setting.find(1).xero_consumer_secret 
 
  def initialize
    path = Rails.root + "config/privatekey.pem"
    # Create client (used to communicate with the API).
    self.client = Xeroizer::PrivateApplication.new(CONSUM_KEY, OAUTH_SECRET_KEY, path)
  end
  
  def create_invoice(booking)
    #if we have a lead customer create contact in xero if it does not already exist. 
    #self.customers.each do |cust| # xero only allows one contact per invoice. 
    cust = booking.customer  
    xcontacts = self.client.Contact.all(:where => {:name => cust.fullname})
    if xcontacts.blank? && !cust.email.nil?
      # try match on email
      xcontacts = self.client.Contact.all(:where => {:email_address => cust.email})
    end

    if xcontacts.blank? 
    puts "HAMISH - no match"
      #add contact to xero
      xcust = self.client.Contact.build(:name => cust.fullname)
      xcust.first_name = cust.first_name
      xcust.last_name =  cust.last_name
      xcust.email_address = cust.email
      #xcust.add_address(:type => 'STREET', :line1 => '12 Testing Lane', :city => 'Brisbane') # TO BE ADDED
      #xcust.add_phone(:type => 'DEFAULT', :area_code => '07', :number => '3033 1234')  # TO BE ADDED
      xcust.add_phone(:type => 'MOBILE', :number => cust.mobile)  # ADD nomal phone - may need to structure our phone records like xero does. 
      xcust.save
    else
      xcust = xcontacts.first
    end
    
    xinv = self.client.Invoice.build({
      :type => "ACCREC",
     # :status => "SUBMITTED",
      :status => "AUTHORISED",
      :date => Date.today,
      :due_date => (Date.today + 30),
      :line_items => [{
        :description => booking.name,
        :quantity => 1,
        :unit_amount => booking.amount,
        :account_code => 200,
        :tax_type => 'NONE'
        }]
      })
    
    xinv.contact = xcust
    success = xinv.save
    
    cust.update_attribute(:xero_id, xcust.contact_id)
    booking.update_attribute(:xero_id, xinv.invoice_id)
    
    return success;
  end
  
  def create_payment(booking, amount)
    
    xInv = self.client.Invoice.find(booking.xero_id)
    xAcc = self.client.Account.find('200')
    xPay = self.client.Payment.build(:amount => amount, :date => Date.today, :reference => "Manual payment made via Tripease application")
    xPay.invoice = xInv
    xPay.account = xAcc
    
    xPay.save
    #xInv.save
    
    arr = booking.xpayments || []
    arr <<   xPay.payment_id
    booking.update_attribute(:xpayments, arr)
  end
  
  def change_invoice(booking, amount)
    
    xInv = self.client.Invoice.find(booking.xero_id)
    
    payArray = []
    xInv.payments.each do |pay|
    #booking.xpayments.each do |pay|
      deletePay =  self.client.Payment.build
      deletePay.payment_id = pay.payment_id
      deletePay.status = "DELETED"    
      deletePay.save
      payArray << pay
    end
    
    li = xInv.line_items.first
    li.unit_amount = amount.to_f
    xInv.save  
    
    xAcc = self.client.Account.find('200')
    arr = []
    
    payArray.each do |pay|  
      xPay = self.client.Payment.build(:amount => pay.amount, :date => pay.date, :reference => pay.reference)
      xPay.invoice = xInv
      xPay.account = xAcc

      xPay.save

      arr <<   xPay.payment_id
    end 
    booking.update_attribute(:xpayments, arr)   
  end
  
  def get_invoice(xero_id)
    if xero_id.blank? 
      return
    end
    
    inv = self.client.Invoice.find(xero_id)
    return inv
  end
end
