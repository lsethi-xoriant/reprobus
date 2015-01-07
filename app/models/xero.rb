class Xero
# using PrivateApplication which expires every 30 days!!!
  
   require 'rubygems'
   require 'xeroizer'
  
  attr_accessor :client
  
   CONSUM_KEY = "SJXI8AQKB8GYBQSG9VLHJJ3QNJ13JV"
   OAUTH_SECRET_KEY = "T7K1GEBJZUZMUYA3PXQHIEXXMZRAJS"
  
  def initialize
    path = Rails.root + "config/privatekey.pem"
    # Create client (used to communicate with the API).
    self.client = Xeroizer::PrivateApplication.new(CONSUM_KEY, OAUTH_SECRET_KEY, path)
  end
  
  def create_invoice(enquiry)
    #if we have a lead customer create contact in xero if it does not already exist. 
    #self.customers.each do |cust| # xero only allows one contact per invoice. 
    cust = enquiry.customers.first   
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
      :status => "SUBMITTED",
      :date => Date.today,
      :due_date => (Date.today + 30),
      :line_items => [{
        :description => enquiry.name,
        :quantity => 1,
        :unit_amount => enquiry.amount,
        :account_code => 200,
        :tax_type => 'NONE'
        }]
      })
    
    xinv.contact = xcust
    xinv.save
    
    cust.update_attribute(:xero_id, xcust.contact_id)
    enquiry.update_attribute(:xero_id, xinv.invoice_id)
  end
  
  def create_payment(enquiry, amount)
    puts enquiry.name
    puts self.client
    
    xInv = self.client.Invoice.find(enquiry.xero_id)
    xAcc = self.client.Account.find('855')
    #xPay = xInv.add_payment(:amount => amount, :date => Date.today, :reference => "Manual payment made via Tripease application")
    xPay = self.client.Payment.build(:amount => amount, :date => Date.today, :reference => "Manual payment made via Tripease application")
    xPay.invoice = xInv
    xPay.account = xAcc
    
    xPay.save
    #xInv.save
    
    arr = enquiry.xpayments || []
    arr <<   xPay.payment_id
    enquiry.update_attribute(:xpayments, arr)
  end
  
  def get_invoice(xero_id)
    if xero_id.blank? 
      return
    end
    
    inv = self.client.Invoice.find(xero_id)
    return inv
  end
end
