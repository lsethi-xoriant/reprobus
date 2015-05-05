# == Schema Information
#
# Table name: bookings
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  enquiry_id  :integer
#  user_id     :integer
#  amount      :decimal(12, 2)
#  deposit     :decimal(12, 2)
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  xpayments   :text
#  xero_id     :string(255)
#  xdeposits   :text
#  agent_id    :integer
#

class Booking < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :enquiry
  belongs_to  :customer
  serialize   :xpayments
  has_many    :customer_invoices, :class_name => "Invoice", :foreign_key => :customer_invoice_id
  has_many    :supplier_invoices, :class_name => "Invoice", :foreign_key => :supplier_invoice_id
  belongs_to  :agent, :class_name => "Customer", :foreign_key => :agent_id
  
  def getCustomerInvoicesAmount
    tot = 0
    self.customer_invoices.each do |i|
      tot = tot  + i.exchange_amount
    end
    return tot
  end
  def getSupplierInvoicesAmount
    tot = 0
    self.supplier_invoices.each do |i|
      tot = tot  + i.exchange_amount
    end
    return tot
  end
  def getCustomerInvoicesDepositAmount
    tot = 0
    self.customer_invoices.each do |i|
      tot = tot  + i.deposit unless i.deposit.nil?
    end
    return tot
  end
  def initInvoiceDates
    if !self.enquiry.est_date.blank?
      if (self.enquiry.est_date - 90) > Date.today && self.enquiry.est_date > Date.today
        return (self.enquiry.est_date - 90), (self.enquiry.est_date - 30)
      elsif (self.enquiry.est_date - 30) > Date.today
        return (self.enquiry.est_date - 30), (self.enquiry.est_date - 30)
      else
        return (Date.today), (Date.today)
      end
    else
      return (Date.today + 30), (Date.today + 60)
    end
  end

  def initSupInvoiceDate
     if !self.enquiry.est_date.blank?
       return self.enquiry.est_date - 30
     else
       return (Date.today + 30)
     end
  end
  
  def dasboard_customer_name
    if !self.customer.nil?
      self.customer.dashboard_name
    else
      "No Customer Details"
    end
  end
  
  def assigned_to_name
    if self.user
      self.user.name
    end
  end
  
  def created_by_name
    self.user.name
    #User.find(self.user_id).name
  end
  
  def nice_id
    self.id.to_s.rjust(6, '0')
  end
  
  def trigger_new_booking
    trigger = Setting.find(1).triggers.find_by_name("New Booking")
    
    if trigger.email_template
      if trigger.num_days.blank? || trigger.num_days == 0
        # do job now.
        SendEmailTemplateJob.perform_later(trigger.email_template, self.user.email, self.enquiry.customer_email)
      else
        # do job in a number of days.
        secs = 0
        secs = trigger.num_days * 60 * 60 * 24
        SendEmailTemplateJob.set(wait: secs.seconds).perform_later(trigger.email_template,self.user.email, self.enquiry.customer_email)
      end
    end
  end
end
