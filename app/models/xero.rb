class Xero
# using PrivateApplication which expires every 30 days!!!
  
  require 'rubygems'
  require 'xeroizer'
  
  attr_accessor :client
  
  #CONSUM_KEY = "VNC0RNRCXH3BPNK4GDCK0J4SLMSX68"  // dev testing key
  #OAUTH_SECRET_KEY = "DBDRCQLMZABOSGZHCBTVWLXTCJDRUA" // dev testing
  
  CONSUM_KEY = Setting.find(1).xero_consumer_key
  OAUTH_SECRET_KEY = Setting.find(1).xero_consumer_secret
 
  def initialize
    path = Rails.root + "config/privatekey.pem"
    # Create client (used to communicate with the API).
    self.client = Xeroizer::PrivateApplication.new(CONSUM_KEY, OAUTH_SECRET_KEY, path)
  end
  
  def getContact(cust)
    xcontacts = self.client.Contact.all(:where => {:name => cust.fullname})
    if xcontacts.blank? && !cust.email.nil?
      # try match on email
      xcontacts = self.client.Contact.all(:where => {:email_address => cust.email})
    end

    if xcontacts.blank?
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
    return xcust
  end
  
  def create_invoice(invoice)

    itinerary = invoice.itinerary_price.itinerary

    #if we have a lead customer create contact in xero if it does not already exist.
    #self.customers.each do |cust| # xero only allows one contact per invoice.
    if invoice.isSupplierInvoice?
      cust = invoice.supplier
    else
      cust = itinerary.lead_customer
    end
    
    xcust = self.getContact(cust)
    
    if invoice.isSupplierInvoice?
      type = "ACCPAY";
    else
      type = "ACCREC";
    end
    
    currency = invoice.getCurrencyCode

    xinv = self.client.Invoice.build({
      :type => type,
     # :status => "SUBMITTED",
      :status => "AUTHORISED",
      :date => Date.today,
      :due_date => invoice.final_payment_due,
      :currency_code => currency,
      :line_items => [{
        :description => itinerary.name,
        :quantity => 1,
        :unit_amount => invoice.getTotalAmount,
        :account_code => 200,
        :tax_type => 'NONE'
        }]
      })
    
    if invoice.isSupplierInvoice?
      xinv.invoice_number = itinerary.nice_id + " " + itinerary.name
    end
    
    xinv.contact = xcust
    success = xinv.save
    
    cust.update_attribute(:xero_id, xcust.contact_id)
    
    if success
      invoice.update_attribute(:xero_id, xinv.invoice_id)
      invoice.create_x_invoice(amount_due: xinv.amount_due, amount_paid: xinv.amount_paid, total: xinv.total, currency_code: xinv.currency_code,
                               currency_rate: xinv.currency_rate, date: xinv.date, invoice_ref: xinv.invoice_id,
                               invoice_number: xinv.invoice_number, status: xinv.status, due_date: xinv.due_date, last_sync: Time.now)
    end
    
    return success;
  end
  
  def create_payment(invoice, amount)
    
    xInv = self.client.Invoice.find(invoice.xero_id)
    xAcc = self.client.Account.find('855')
    xPay = self.client.Payment.build(:amount => amount, :date => Date.today, :reference => "Manual payment made via tripeze application")
    xPay.invoice = xInv
    xPay.account = xAcc
    
    xPay.save
    #xInv.save
    
    arr = invoice.xpayments || []
    arr <<   xPay.payment_id
    invoice.update_attribute(:xpayments, arr)
    
    new_pay = invoice.payments.create(payment_ref: xPay.payment_id, amount: amount, date: xPay.date, reference: xPay.reference)
    Trigger.trigger_pay_receipt(invoice, new_pay) if new_pay
  end
  
  def sync_invoices(invoices)
    # syncs invoices with xero. Will call single sync method that will update payment details and check receipt has been sent.
    logStr = ""
    
    invoices.each do |invoice|
      # investigate doing this in one hit... possible xero.invoices.all with a where clause.
      begin
      self.sync_invoice(invoice)
      logStr = logStr + "... synced invoice #{invoice.id}, xero invoice #{invoice.x_invoice.invoice_number}<br>"
      rescue StandardError
        logStr = logStr + "Warning - Invoice #{invoice.id} could not be synced<br>"
      end
    end
    return logStr
  end
  
  def sync_invoice(invoice)
    # syncs a single invoices
    
    # find xero invoice
    xInv = self.client.Invoice.find(invoice.xero_id)
    
    # work through current payment and determine if we have already matched.
    #build up collection of previous reconciled ids,
    currIds = invoice.payments.map{|p| p.payment_ref}
    # build up collection of payment amounts for cc's that have not been reconciled
    ccPayments = invoice.payments.ccPayments.notReconciled

    xInv.payments.each do |xpay|
      if !currIds.include?(xpay.payment_id)
        # we dont have a referrence for this payment, so we need to reconcile it.
        # check if any cc payments exist that we have not reconciled. if we find one, we dont need to create a payment, but we need to match it
        payment = ccPayments.find_by_amount(xpay.amount)
        if payment
          # update the payment_id.
          payment.update_attribute("payment_ref", xpay.payment_id)
          #done, don't need to hit trigger, as payment receipt would already been sent.
        else
          # no cc payment, and no previous sync payment. Create a new one.
          new_pay = invoice.payments.create(payment_ref: xpay.payment_id, amount: xpay.amount, date: xpay.date, reference: xpay.reference)
          # hit trigger for payment receipt as this is the first time we have seen this payment.
          Trigger.trigger_pay_receipt(invoice, new_pay) if new_pay
        end
      end
    end
    
    if !invoice.x_invoice
      invoice.create_x_invoice(amount_due: xInv.amount_due, amount_paid: xInv.amount_paid, total: xInv.total, currency_code: xInv.currency_code,
                               currency_rate: xInv.currency_rate, date: xInv.date, invoice_ref: xInv.invoice_id,
                               invoice_number: xInv.invoice_number, status: xInv.status, due_date: xInv.due_date, last_sync: Time.now)
    else
      invoice.x_invoice.update_attributes(amount_due: xInv.amount_due, amount_paid: xInv.amount_paid, total: xInv.total, currency_code: xInv.currency_code,
                               currency_rate: xInv.currency_rate, date: xInv.date, invoice_ref: xInv.invoice_id,
                               invoice_number: xInv.invoice_number, status: xInv.status, due_date: xInv.due_date, last_sync: Time.now)
    end
  end
 
  def change_invoice(invoice, amount)
    
    xInv = self.client.Invoice.find(invoice.xero_id)
    
    # currently we do not allow the changing xero amount if there are payments - however code left incase we change our mind
    payArray = []
    xInv.payments.each do |pay|
      deletePay =  self.client.Payment.build
      deletePay.payment_id = pay.payment_id
      deletePay.status = "DELETED"
      deletePay.save
      payArray << pay
    end
    
    #back to actual code that updates price
    li = xInv.line_items.first
    li.unit_amount = amount.to_f
    if xInv.save then 
      # save ok, so update our sync xinvoice invoice with the new price
      invoice.x_invoice.update_attributes(amount_due: amount, last_sync: Time.now)
    end
    
    xAcc = self.client.Account.find('855')
    arr = []
    
    # currently we do not allow the changing xero amount if there are payments - however code left incase we change our mind
    payArray.each do |pay|
      xPay = self.client.Payment.build(:amount => pay.amount, :date => pay.date, :reference => pay.reference)
      xPay.invoice = xInv
      xPay.account = xAcc

      xPay.save

      arr <<   xPay.payment_id
    end
    invoice.update_attribute(:xpayments, arr)
    
  end
  
  def get_invoice(xero_id)
    if xero_id.blank?
      return
    end
    
    inv = self.client.Invoice.find(xero_id)
    return inv
  end
end
